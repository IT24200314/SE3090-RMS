import { test, expect } from '@playwright/test';

test.describe('Rental Management System - Core Workflows', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('body')).toBeVisible();
  });

  test('Flow 1: Draft Lease and verify Property status transition', async ({ page }) => {
    // 1. Navigate to Properties tab
    await page.click('button:has-text("Properties & Leases")');
    
    // 2. Locate first Available property card and click Draft Lease
    const propertyCard = page.locator('[data-testid="property-card"]').first();
    await expect(propertyCard).toBeVisible();
    await propertyCard.locator('button:has-text("Draft Lease")').click();

    // 3. Verify Lease Modal opened
    const modal = page.locator('[role="dialog"]');
    await expect(modal).toBeVisible();
    await expect(modal.locator('text=Draft Lease Agreement')).toBeVisible();

    // 4. Fill lease parameters and submit
    await modal.locator('input[name="monthlyRent"]').fill('220000');
    await modal.locator('button[type="submit"]').click();

    // 5. Verify modal closes and status changes to Occupied
    await expect(modal).not.toBeVisible();
    await expect(propertyCard.locator('text=Occupied')).toBeVisible();
  });

  test('Flow 2: Enforce LKR 50,000 HITL Maintenance Policy Safeguard', async ({ page }) => {
    // 1. Navigate to Maintenance Board
    await page.click('button:has-text("Maintenance & Dispatch")');

    // 2. Verify high-cost emergency card is routed to Manager Approval
    const hitlCard = page.locator('[data-testid="hitl-approval-card"]').first();
    await expect(hitlCard).toBeVisible();
    await expect(hitlCard).toContainText('LKR 50,000 Threshold Exceeded');

    // 3. Manager authorizes the high-cost repair
    const approveBtn = hitlCard.locator('button:has-text("Authorize Repair")');
    await expect(approveBtn).toBeEnabled();
    await approveBtn.click();

    // 4. Verify card resolves from approval queue
    await expect(hitlCard).not.toBeVisible();
  });

  test('Flow 3: Telemetry View renders Multi-Agent state nodes', async ({ page }) => {
    // 1. Open Agentic AI Telemetry tab
    await page.click('button:has-text("Agentic AI Trace")');

    // 2. Trigger simulation
    await page.click('button:has-text("Simulate Agent Run")');

    // 3. Verify state execution nodes appear
    await expect(page.locator('text=Upamada (Planning Agent)').first()).toBeVisible();
    await expect(page.locator('text=LangGraph StateGraph Telemetry')).toBeVisible();
  });

});
