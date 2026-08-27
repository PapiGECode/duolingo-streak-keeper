import { Page } from 'playwright';
import { captureSessionData } from './network';
import { Session } from '../interfaces';

async function dismissUpgradePrompt(page: Page): Promise<boolean> {
    const dismissButton = page.getByRole('button', { name: /^(No, gracias|No thanks|Not now)$/i });
    if (!await dismissButton.isVisible().catch(() => false)) {
        return false;
    }

    console.log('Closing the optional upgrade prompt...');
    await dismissButton.click();
    await page.waitForTimeout(250);
    return true;
}

/**
 * Navigates to the Practice Hub and starts the vocabulary lesson.
 * Handles navigation, button clicks, and robust Start button interaction.
 */
export async function startWordsLesson(page: Page): Promise<Session | null> {
    console.log('Navigating to Words lesson...');

    // Going directly to the hub is more reliable than depending on the current
    // page's navigation layout.
    if (!page.url().includes('/practice-hub')) {
        await page.goto('https://www.duolingo.com/practice-hub', { waitUntil: 'domcontentloaded' });
    }

    // Duolingo localizes collection labels. The data-test id is stable, but the
    // former English-only "Words" match fails for users with a Spanish UI.
    const wordsButton = page.getByRole('button', { name: /^(Words|Palabras)\b/i });
    await wordsButton.waitFor({ state: 'visible', timeout: 10000 });
    console.log('Clicking Words button...');
    await wordsButton.click();
    await wordsButton.waitFor({ state: 'hidden', timeout: 10000 });
    const sessionDataPromise = captureSessionData(page, 30000);

    const startButton = page.getByRole('button', { name: /START|REVIEW|EMPEZAR|REPASAR/i }).first();
    console.log('Clicking Start button...');
    await startButton.waitFor({ timeout: 10000 });
    await startButton.click();

    // Duolingo may show a Super upsell instead of opening the session. Close it
    // and retry the start action once so the session request can be captured.
    if (await dismissUpgradePrompt(page)) {
        await startButton.click();
    }

    await startButton.waitFor({ state: 'hidden', timeout: 10000 });

    return await sessionDataPromise;
}
