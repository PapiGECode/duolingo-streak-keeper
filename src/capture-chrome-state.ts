import { chromium } from 'playwright';
import { getStatePath, isLoggedIn } from './utils/auth.js';

(async () => {
    const browser = await chromium.connectOverCDP('http://127.0.0.1:9222');

    try {
        const contexts = browser.contexts();
        if (contexts.length === 0) {
            throw new Error('No Chrome context found.');
        }

        const context = contexts[0];
        let pages = context.pages();
        let page = pages.find(p => p.url().includes('duolingo.com'));

        if (!page) {
            page = await context.newPage();
            await page.goto('https://www.duolingo.com/learn', {
                waitUntil: 'domcontentloaded'
            });
        } else if (!page.url().includes('/learn')) {
            await page.goto('https://www.duolingo.com/learn', {
                waitUntil: 'domcontentloaded'
            });
        }

        await page.waitForTimeout(1500);

        if (!await isLoggedIn(page)) {
            console.error('❌ Duolingo login was not detected in the normal Chrome profile.');
            process.exitCode = 2;
            return;
        }

        const statePath = getStatePath();
        await context.storageState({ path: statePath });
        console.log(`✅ Duolingo session saved to: ${statePath}`);
    } finally {
        await browser.close();
    }
})();