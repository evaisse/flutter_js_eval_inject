const { test, expect } = require('@playwright/test');

test.describe('Flutter JS Eval Inject Demo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    // Wait for Flutter app to load
    await page.waitForTimeout(3000);
  });

  test('should display the main UI elements', async ({ page }) => {
    // Check title
    await expect(page.locator('text=Flutter JS Eval Inject Demo')).toBeVisible();
    
    // Check labels
    await expect(page.locator('text=JavaScript Code:')).toBeVisible();
    await expect(page.locator('text=JavaScript File URL:')).toBeVisible();
    await expect(page.locator('text=Output:')).toBeVisible();
    
    // Check buttons
    await expect(page.locator('text=Add JS Code')).toBeVisible();
    await expect(page.locator('text=Load JS File')).toBeVisible();
    await expect(page.locator('text=Eval JS')).toBeVisible();
    await expect(page.locator('text=Test Lodash')).toBeVisible();
    await expect(page.locator('text=Test Complex')).toBeVisible();
  });

  test('should evaluate simple JavaScript code', async ({ page }) => {
    // Clear the JavaScript code field and enter simple code
    const codeField = page.locator('textarea').first();
    await codeField.click();
    await codeField.fill('2 + 2');
    
    // Click Eval JS button
    await page.locator('text=Eval JS').click();
    
    // Wait for result
    await page.waitForTimeout(1000);
    
    // Check output
    const output = page.locator('text=Result: 4');
    await expect(output).toBeVisible();
  });

  test('should add and execute JavaScript function', async ({ page }) => {
    // Enter a simple function
    const codeField = page.locator('textarea').first();
    await codeField.click();
    await codeField.fill(`
      function multiply(a, b) {
        return a * b;
      }
      multiply(5, 3)
    `);
    
    // Click Add JS Code first
    await page.locator('text=Add JS Code').click();
    await page.waitForTimeout(500);
    
    // Then evaluate
    await page.locator('text=Eval JS').click();
    await page.waitForTimeout(1000);
    
    // Check output
    const output = page.locator('text=Result: 15');
    await expect(output).toBeVisible();
  });

  test('should handle JavaScript errors gracefully', async ({ page }) => {
    // Enter invalid JavaScript
    const codeField = page.locator('textarea').first();
    await codeField.click();
    await codeField.fill('undefined.nonExistentMethod()');
    
    // Click Eval JS
    await page.locator('text=Eval JS').click();
    await page.waitForTimeout(1000);
    
    // Check for error message
    const errorOutput = page.locator('text=/Error.*JavaScript/');
    await expect(errorOutput).toBeVisible();
  });

  test('should execute complex JavaScript API', async ({ page }) => {
    // Click Test Complex button
    await page.locator('text=Test Complex').click();
    
    // Wait for result
    await page.waitForTimeout(1500);
    
    // Check that complex eval result appears
    const output = page.locator('text=/Complex eval result:.*sum.*product/');
    await expect(output).toBeVisible();
  });

  test('should load external JavaScript library', async ({ page }) => {
    // Test loading Lodash
    await page.locator('text=Test Lodash').click();
    
    // Wait for library to load and execute
    await page.waitForTimeout(2000);
    
    // Check for Lodash test result
    const output = page.locator('text=/Lodash test result:.*1.*4.*9.*16/');
    await expect(output).toBeVisible();
  });

  test('should handle custom JavaScript file URL', async ({ page }) => {
    // Enter a CDN URL for a simple library
    const fileField = page.locator('input[type="text"]').last();
    await fileField.click();
    await fileField.fill('https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js');
    
    // Load the file
    await page.locator('text=Load JS File').click();
    await page.waitForTimeout(1500);
    
    // Verify success message
    const successMessage = page.locator('text=JavaScript file loaded successfully!');
    await expect(successMessage).toBeVisible();
    
    // Now test if dayjs is available
    const codeField = page.locator('textarea').first();
    await codeField.click();
    await codeField.fill('typeof dayjs !== "undefined" ? "dayjs loaded" : "dayjs not loaded"');
    
    await page.locator('text=Eval JS').click();
    await page.waitForTimeout(1000);
    
    const output = page.locator('text=Result: dayjs loaded');
    await expect(output).toBeVisible();
  });

  test('should preserve JavaScript context across operations', async ({ page }) => {
    // Add a global variable
    const codeField = page.locator('textarea').first();
    await codeField.click();
    await codeField.fill('window.myGlobalVar = 42');
    
    await page.locator('text=Add JS Code').click();
    await page.waitForTimeout(500);
    
    // Access the global variable
    await codeField.fill('window.myGlobalVar * 2');
    await page.locator('text=Eval JS').click();
    await page.waitForTimeout(1000);
    
    const output = page.locator('text=Result: 84');
    await expect(output).toBeVisible();
  });
});