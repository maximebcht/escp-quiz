-- ============================================
-- SEED: AC11 Managerial Accounting Quiz Data
-- Run AFTER schema.sql
-- ============================================

-- Get the AC11 subject ID
DO $$
DECLARE
  v_subject_id UUID;
  v_full_quiz_id UUID;
BEGIN
  SELECT id INTO v_subject_id FROM subjects WHERE code = 'AC11';

  -- Create the full 100-question quiz
  INSERT INTO quizzes (id, subject_id, title, description, lecture_tag, question_count, is_active)
  VALUES (gen_random_uuid(), v_subject_id, 'AC11 – Full Course Quiz', 'Comprehensive 100-question quiz covering all lectures (1–11)', 'Full Course', 100, true)
  RETURNING id INTO v_full_quiz_id;

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'What is the primary purpose of accounting?', '["To calculate taxes for the government", "To provide information about business transactions to users for decision-making", "To record only cash transactions", "To prepare marketing reports"]'::jsonb, 1, 'According to the course, accounting is a system providing information about business transactions to users of accounting information, based on which decisions and judgments are made.', 'Lecture 1', 1);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which of the following is NOT one of the three basic activities of accounting?', '["Identifies", "Records", "Communicates", "Audits"]'::jsonb, 3, 'Accounting consists of three basic activities: it identifies, records, and communicates the economic events of an organization to interested users. Auditing is a separate function.', 'Lecture 1', 2);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which branch of accounting supplies the necessary information to management for better decision-making including funds, costs, profits, and losses?', '["Financial accounting", "Tax accounting", "Management accounting", "Social accounting"]'::jsonb, 2, 'Management accounting supplies the necessary information to the management for better decision-making including funds, costs, profits, and losses.', 'Lecture 1', 3);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Internal users of accounting information include:', '["Investors and creditors", "Owners, managers, and employees", "Tax authorities and regulators", "Banks and suppliers"]'::jsonb, 1, 'Internal users are people involved in a business''s day-to-day operations and long-term strategic planning. Examples of internal users are owners, managers, and employees.', 'Lecture 1', 4);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'According to the basic accounting equation, which of the following is correct?', '["Assets = Liabilities − Stockholders'' Equity", "Assets = Liabilities + Stockholders'' Equity", "Liabilities = Assets + Stockholders'' Equity", "Stockholders'' Equity = Assets + Liabilities"]'::jsonb, 1, 'The basic accounting equation is Assets = Liabilities + Stockholders'' Equity. It provides the underlying framework for recording and summarizing economic events.', 'Lecture 1', 5);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which financial statement reports the assets, liabilities, and stockholders'' equity at a specific date?', '["Income statement", "Statement of cash flows", "Balance sheet", "Retained earnings statement"]'::jsonb, 2, 'The balance sheet reports the assets, liabilities, and stockholders'' equity at a specific date. It is a snapshot of the company''s financial condition at a specific moment in time.', 'Lecture 1', 6);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Net income results during a time period when:', '["Assets exceed liabilities", "Expenses exceed revenues", "Revenues exceed expenses", "Assets exceed revenues"]'::jsonb, 2, 'Net income results when revenues exceed expenses. If expenses exceed revenues, the result is a net loss.', 'Lecture 1', 7);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which of the following is a key difference between financial accounting and managerial accounting?', '["Financial accounting focuses on future-oriented data while managerial accounting focuses on historical data", "Financial accounting serves external users while managerial accounting serves internal users", "Financial accounting does not follow any regulatory standards", "Managerial accounting must follow GAAP and IFRS"]'::jsonb, 1, 'Financial accounting focuses on providing a historical and standardized view to external parties, while managerial accounting provides detailed and relevant information to internal users for decision-making and strategic planning.', 'Lecture 1', 8);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Retained earnings represent:', '["The total cash available to the company", "The amount of profit left over after paying all costs, taxes, and dividends to shareholders", "The total liabilities of the company", "The initial investment by stockholders"]'::jsonb, 1, 'Retained earnings are the amount of profit a company has left over after paying all its direct costs, indirect costs, income taxes, and its dividends to shareholders.', 'Lecture 1', 9);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The income statement is sometimes referred to as the:', '["Balance sheet", "Statement of financial position", "Profit and loss statement", "Cash flow report"]'::jsonb, 2, 'The income statement is sometimes referred to as the statement of operations, earnings statement, or profit and loss statement.', 'Lecture 1', 10);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'What are the three main components of manufacturing costs?', '["Selling costs, administrative costs, and overhead", "Direct materials, direct labor, and manufacturing overhead", "Fixed costs, variable costs, and mixed costs", "Product costs, period costs, and sunk costs"]'::jsonb, 1, 'Most manufacturing companies separate manufacturing costs into three main components: direct materials, direct labor, and manufacturing overhead.', 'Lecture 2', 11);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A cost object is best described as:', '["An expense that has already been incurred and cannot be recovered", "Something you want to calculate the cost of, whether it''s a product, a service, or a function", "A cost that varies with the level of production", "A cost that remains the same regardless of activity"]'::jsonb, 1, 'A cost object is something you want to calculate the cost of, whether it''s a product, a service, a function in the company, a store, and so on.', 'Lecture 2', 12);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which of the following is an example of manufacturing overhead?', '["Raw materials used directly in production", "Wages of assembly-line workers", "Depreciation on factory equipment", "Sales commissions"]'::jsonb, 2, 'Manufacturing overhead includes costs indirectly associated with manufacturing, such as indirect materials, indirect labor, depreciation on factory equipment, and factory rent. Sales commissions are selling costs (non-manufacturing).', 'Lecture 2', 13);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Non-manufacturing costs are divided into which two categories?', '["Direct costs and indirect costs", "Fixed costs and variable costs", "Selling costs and administrative costs", "Product costs and period costs"]'::jsonb, 2, 'Non-manufacturing costs are often divided into two categories: selling costs and administrative costs.', 'Lecture 2', 14);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Product costs include:', '["Only direct materials and direct labor", "Direct materials, direct labor, and manufacturing overhead", "Selling and administrative expenses", "All costs incurred by the business"]'::jsonb, 1, 'Product costs have three components: direct materials, direct labor, and manufacturing overhead. They are recorded in the inventory account until goods are sold.', 'Lecture 2', 15);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Period costs are:', '["Included in the cost of inventory on the balance sheet", "Charged to expense as incurred and include all selling and administrative expenses", "Only incurred during the manufacturing process", "Costs that vary with production volume"]'::jsonb, 1, 'Period costs are charged to expense as incurred. They are non-manufacturing costs and include all selling and administrative expenses.', 'Lecture 2', 16);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Prime costs are the sum of:', '["Direct labor cost and manufacturing overhead cost", "Direct materials cost and direct labor cost", "Direct materials cost and manufacturing overhead cost", "All manufacturing and non-manufacturing costs"]'::jsonb, 1, 'Prime costs are the sum of direct materials cost and direct labor cost.', 'Lecture 2', 17);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Conversion costs are the sum of:', '["Direct materials cost and direct labor cost", "Direct labor cost and manufacturing overhead cost", "Direct materials cost and manufacturing overhead cost", "Selling costs and administrative costs"]'::jsonb, 1, 'Conversion costs are the sum of direct labor cost and manufacturing overhead cost. These costs are incurred to convert materials into the finished products.', 'Lecture 2', 18);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'An opportunity cost is best described as:', '["A cost that has already been incurred and cannot be recovered", "The value of the next best alternative that is foregone when making a decision", "A cost that remains constant regardless of the level of activity", "A cost directly traceable to a specific product"]'::jsonb, 1, 'Opportunity cost is the value of the next best alternative that is foregone when making a decision. It is forward-looking and should be considered in decision-making.', 'Lecture 2', 19);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A sunk cost is a cost that:', '["Changes in proportion to production volume", "Has already been incurred and cannot be recovered", "Will be incurred in the future", "Can be directly traced to a cost object"]'::jsonb, 1, 'A sunk cost refers to a cost that has already been incurred and cannot be recovered. Sunk costs are irrelevant to the decision-making process because they cannot be altered by future actions.', 'Lecture 2', 20);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Cost behavior analysis is the study of how costs change in response to:', '["Changes in tax regulations", "Variations in an organization''s level of activity", "Changes in the stock market", "Fluctuations in currency exchange rates"]'::jsonb, 1, 'Cost behavior analysis is the study of how costs change in response to variations in an organization''s level of activity, often measured in terms of units produced, hours worked, or sales volume.', 'Lecture 3', 21);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A cost driver is best defined as:', '["A cost that cannot be changed", "Any activity that triggers a cost of something else", "A fixed expense that does not vary", "The total cost of production"]'::jsonb, 1, 'A cost driver is any activity that triggers a cost of something else. For example, the units of water consumed drive the water bill.', 'Lecture 3', 22);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which statement about variable costs is correct?', '["Total variable costs remain constant as activity changes", "Variable cost per unit changes as the activity level changes", "Variable costs vary in total directly and proportionately with changes in the activity level", "Variable costs include rent and insurance"]'::jsonb, 2, 'Variable costs vary in total directly and proportionately with changes in the activity level. However, the variable cost per unit remains the same at every level of activity.', 'Lecture 3', 23);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company produces widgets at a variable cost of $8 per unit. If it produces 2,000 units, what is the total variable cost?', '["$8,000", "$16,000", "$4,000", "$12,000"]'::jsonb, 1, 'Total Variable Cost = Variable Cost per Unit × Number of Units Produced = $8 × 2,000 = $16,000.', 'Lecture 3', 24);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Fixed cost per unit:', '["Remains the same regardless of the activity level", "Varies inversely with the activity level", "Increases as production increases", "Is always higher than variable cost per unit"]'::jsonb, 1, 'Fixed cost per unit varies inversely with activity. As volume increases, the fixed cost per unit declines, and vice versa.', 'Lecture 3', 25);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Mixed costs are also known as:', '["Sunk costs", "Opportunity costs", "Semi-variable costs", "Prime costs"]'::jsonb, 2, 'Mixed costs, also known as semi-variable costs, are expenses that have both fixed and variable components.', 'Lecture 3', 26);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The relevant range refers to:', '["The range of activity levels over which a company''s cost structure remains consistent", "The maximum production capacity of a company", "The range of prices a company can charge", "The minimum sales needed to cover all costs"]'::jsonb, 0, 'The relevant range refers to the range of activity levels over which a company''s cost structure remains consistent. Within this range, fixed costs remain unchanged and variable costs vary in direct proportion.', 'Lecture 3', 27);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Using the high-low method, the formula for variable cost per unit is:', '["Total cost ÷ Total activity", "Change in cost ÷ Change in activity", "Fixed cost ÷ Number of units", "Total revenue − Total cost"]'::jsonb, 1, 'In the high-low method, Variable cost per unit = Change in cost ÷ Change in activity, using the highest and lowest activity levels.', 'Lecture 3', 28);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Using the high-low method: High activity = 6,000 units at $40,000 total cost; Low activity = 2,000 units at $20,000 total cost. What is the variable cost per unit?', '["$3", "$5", "$7", "$10"]'::jsonb, 1, 'Variable cost per unit = (40,000 − 20,000) ÷ (6,000 − 2,000) = 20,000 ÷ 4,000 = $5 per unit.', 'Lecture 3', 29);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A limitation of the high-low method is that:', '["It uses all available data points for maximum accuracy", "It only uses two data points and might not represent overall cost behavior", "It cannot separate fixed and variable costs", "It requires complex statistical software"]'::jsonb, 1, 'The high-low method only uses two data points (high and low) and might not represent the overall cost behavior. It also assumes that cost behavior is linear.', 'Lecture 3', 30);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The contribution margin is calculated as:', '["Sales Revenue + Variable Costs", "Sales Revenue − Fixed Costs", "Sales Revenue − Variable Costs", "Fixed Costs − Variable Costs"]'::jsonb, 2, 'Contribution Margin = Sales Revenue − Variable Costs. It represents the amount of revenue remaining after deducting variable costs.', 'Lecture 4', 31);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A product has a selling price of $80 and a variable cost of $50. What is the contribution margin per unit?', '["$130", "$30", "$50", "$80"]'::jsonb, 1, 'Contribution Margin per Unit = Selling Price per Unit − Variable Cost per Unit = $80 − $50 = $30.', 'Lecture 4', 32);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The contribution margin ratio is calculated as:', '["Variable Costs ÷ Sales", "Fixed Costs ÷ Sales", "Contribution Margin ÷ Sales", "Net Income ÷ Sales"]'::jsonb, 2, 'The contribution margin ratio is normally expressed as a percentage of revenues from sales: Contribution Margin ÷ Sales × 100.', 'Lecture 4', 33);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Cost-Volume-Profit (CVP) analysis focuses on how profits are affected by all of the following EXCEPT:', '["Selling price", "Sales volume", "Interest rates on bank loans", "Total fixed costs"]'::jsonb, 2, 'CVP analysis focuses on how profits are affected by selling price, sales volume, unit variable costs, total fixed costs, and mix of products sold. Interest rates on bank loans are not a factor in CVP analysis.', 'Lecture 4', 34);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The break-even point is the level of sales at which:', '["Total revenues exceed total costs by the target profit", "Total revenues equal total costs, resulting in zero profit", "Fixed costs equal variable costs", "The contribution margin equals zero"]'::jsonb, 1, 'The break-even point is the level of sales at which total revenues equal total costs, resulting in neither profit nor loss.', 'Lecture 4', 35);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company has fixed costs of $150,000 and a contribution margin per unit of $25. What is the break-even point in units?', '["3,000 units", "6,000 units", "7,500 units", "5,000 units"]'::jsonb, 1, 'Break-even point in units = Fixed Costs ÷ Contribution Margin per Unit = $150,000 ÷ $25 = 6,000 units.', 'Lecture 4', 36);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company has fixed costs of $200,000 and a contribution margin ratio of 40%. What is the break-even point in sales dollars?', '["$80,000", "$200,000", "$500,000", "$800,000"]'::jsonb, 2, 'Break-even point in dollars = Fixed Costs ÷ Contribution Margin Ratio = $200,000 ÷ 0.40 = $500,000.', 'Lecture 4', 37);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'If fixed costs increase while all other factors remain constant, the break-even point will:', '["Decrease", "Remain the same", "Increase", "Become negative"]'::jsonb, 2, 'When fixed costs rise, the break-even point increases because the company must sell more units to cover the higher fixed costs before it can start making a profit.', 'Lecture 4', 38);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'If variable costs per unit decrease while selling price and fixed costs remain constant, the contribution margin per unit will:', '["Decrease", "Increase", "Remain the same", "Become zero"]'::jsonb, 1, 'If variable costs decrease, the contribution margin per unit increases (CM = SP − VC), allowing each unit sold to contribute more towards covering fixed costs and profit.', 'Lecture 4', 39);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The CVP income statement format reports:', '["Revenues, then cost of goods sold, then gross profit", "Revenues, then variable costs, then contribution margin, then fixed costs, then net income", "Only cash transactions during the period", "Assets, liabilities, and stockholders'' equity"]'::jsonb, 1, 'The CVP income statement format reports: Sales − Variable Costs = Contribution Margin − Fixed Costs = Net Income (Operating Income).', 'Lecture 4', 40);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Target net income analysis determines:', '["The maximum production capacity of a firm", "The sales volume required to achieve a specific profit level", "The amount of fixed costs a company should incur", "The optimal selling price for a product"]'::jsonb, 1, 'Target net income analysis is a method businesses use to determine the sales volume required to achieve a specific profit level.', 'Lecture 5', 41);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The formula for required sales in units to achieve a target net income is:', '["Fixed Costs ÷ Contribution Margin per Unit", "(Fixed Costs + Target Net Income) ÷ Contribution Margin per Unit", "Target Net Income ÷ Fixed Costs", "(Fixed Costs − Target Net Income) ÷ Selling Price"]'::jsonb, 1, 'Required Sales (units) = (Fixed Costs + Target Net Income) ÷ Contribution Margin per Unit.', 'Lecture 5', 42);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company has fixed costs of $80,000, a target net income of $40,000, and a contribution margin per unit of $20. How many units must be sold?', '["4,000", "6,000", "2,000", "8,000"]'::jsonb, 1, 'Required units = ($80,000 + $40,000) ÷ $20 = $120,000 ÷ $20 = 6,000 units.', 'Lecture 5', 43);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The margin of safety measures:', '["The amount by which actual sales exceed break-even sales", "The total fixed costs of the company", "The difference between selling price and variable cost", "The maximum production capacity"]'::jsonb, 0, 'The margin of safety is the amount sales can fall before the break-even point is reached. It equals Actual Sales − Break-Even Sales.', 'Lecture 5', 44);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company has actual sales of $800,000 and break-even sales of $600,000. What is the margin of safety ratio?', '["75%", "25%", "33%", "20%"]'::jsonb, 1, 'Margin of Safety = $800,000 − $600,000 = $200,000. Margin of Safety Ratio = $200,000 ÷ $800,000 = 25%.', 'Lecture 5', 45);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The degree of operating leverage is calculated as:', '["Net Income ÷ Contribution Margin", "Fixed Costs ÷ Variable Costs", "Contribution Margin ÷ Net Income", "Sales ÷ Fixed Costs"]'::jsonb, 2, 'Degree of Operating Leverage = Contribution Margin ÷ Net Income (Operating Income/EBIT).', 'Lecture 5', 46);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company with high operating leverage has:', '["A higher proportion of variable costs relative to fixed costs", "A higher proportion of fixed costs relative to variable costs", "Equal fixed and variable costs", "No fixed costs at all"]'::jsonb, 1, 'A company with high operating leverage has a larger proportion of fixed costs relative to variable costs, meaning changes in sales can lead to more significant changes in operating income.', 'Lecture 5', 47);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'If a company has a degree of operating leverage of 3, a 10% increase in sales would result in what percentage change in operating income?', '["10%", "13%", "30%", "3%"]'::jsonb, 2, 'The DOL means that for every 1% change in sales, operating income changes by 3%. So a 10% increase in sales leads to a 10% × 3 = 30% increase in operating income.', 'Lecture 5', 48);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company sells products at $56 each, has variable costs of $42 per unit, and fixed costs of $320,000. What is the contribution margin ratio?', '["75%", "25%", "50%", "42%"]'::jsonb, 1, 'CM per unit = $56 − $42 = $14. CM ratio = $14 ÷ $56 = 25%.', 'Lecture 5', 49);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Using the data from the previous question (CM ratio = 25%, FC = $320,000), what are the required sales in dollars to earn a net income of $410,000?', '["$1,280,000", "$2,920,000", "$730,000", "$1,460,000"]'::jsonb, 1, 'Required sales in dollars = (Fixed Costs + Target Net Income) ÷ CM Ratio = ($320,000 + $410,000) ÷ 0.25 = $730,000 ÷ 0.25 = $2,920,000.', 'Lecture 5', 50);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Absorption costing is also known as:', '["Variable costing", "Marginal costing", "Full costing", "Activity-based costing"]'::jsonb, 2, 'Absorption costing, also known as full costing, is an accounting method that includes both variable costs and fixed manufacturing overhead costs in the cost of a unit of product.', 'Lecture 6', 51);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Under absorption costing, fixed manufacturing overhead is:', '["Treated as a period cost and expensed immediately", "Allocated to each unit produced", "Excluded from the cost of production", "Only included when units are sold"]'::jsonb, 1, 'Under absorption costing, all manufacturing costs including fixed manufacturing overhead are ''absorbed'' by the units produced. Each unit carries a portion of both variable and fixed costs.', 'Lecture 6', 52);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Absorption costing is required by which standards for external reporting?', '["Only GAAP", "Only IFRS", "Both GAAP and IFRS", "Neither GAAP nor IFRS"]'::jsonb, 2, 'Absorption costing complies with both Generally Accepted Accounting Principles (GAAP) and International Financial Reporting Standards (IFRS), making it the required method for external financial reporting.', 'Lecture 6', 53);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The total product cost (full cost) under absorption costing equals:', '["Direct materials + Direct labor", "Direct materials + Manufacturing overhead", "Prime cost + Production overhead cost", "Selling costs + Administrative costs"]'::jsonb, 2, 'Total product cost (full cost) = Prime cost + Production overhead cost. This excludes the cost of marketing, administration, and financing.', 'Lecture 6', 54);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Under absorption costing, what happens to the fixed manufacturing overhead associated with unsold units?', '["It is expensed immediately on the income statement", "It remains in the inventory account on the balance sheet", "It is returned to the supplier", "It is recorded as a period cost"]'::jsonb, 1, 'Under absorption costing, fixed overhead costs associated with unsold units remain included in inventory costs on the balance sheet. When units are sold, these costs are transferred to cost of goods sold.', 'Lecture 6', 55);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'What incentive might managers have to overproduce under absorption costing?', '["To reduce the selling price of products", "To defer fixed manufacturing overhead into inventory and artificially inflate reported profit", "To increase the company''s tax burden", "To reduce variable costs per unit"]'::jsonb, 1, 'By producing more units than sold, some fixed manufacturing overhead is deferred in inventory. This can artificially inflate profit, helping managers meet targets or qualify for performance-based pay.', 'Lecture 6', 56);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Under variable costing, which costs are included in the cost of a unit of product?', '["All manufacturing costs including fixed overhead", "Only variable production costs", "Only fixed production costs", "All costs including selling and administrative"]'::jsonb, 1, 'Variable costing includes only variable production costs (direct materials, direct labor, and variable manufacturing overhead) in the cost of a unit of product.', 'Lecture 7', 57);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Under variable costing, fixed manufacturing overhead costs are treated as:', '["Product costs allocated to each unit", "Period costs expensed in the period incurred", "Deferred costs carried in inventory", "Conversion costs"]'::jsonb, 1, 'Under variable costing, fixed manufacturing overhead costs are treated as period costs and are expensed in the period in which they are incurred, not included in the cost of the product.', 'Lecture 7', 58);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Variable costing is NOT permitted for external financial reporting under:', '["GAAP only", "IFRS only", "Both GAAP and IFRS", "It is permitted under all standards"]'::jsonb, 2, 'Variable costing is not permitted under GAAP or IFRS for external financial reporting, as it does not allocate fixed manufacturing overhead to products.', 'Lecture 7', 59);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The contribution margin under variable costing is calculated as:', '["Sales − Total costs of production", "Sales − Total variable costs", "Sales − Fixed costs", "Sales − Direct materials only"]'::jsonb, 1, 'Contribution margin = Sales − Total variable costs (which includes variable costs of production AND variable general administrative costs).', 'Lecture 7', 60);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The gross margin under absorption costing is calculated as:', '["Sales − Total variable costs", "Sales − Total costs of production", "Sales − Fixed costs only", "Sales − Period costs"]'::jsonb, 1, 'Gross margin = Sales − Total costs of production (which includes both variable and fixed production costs under absorption costing).', 'Lecture 7', 61);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'When evaluating a special order with spare capacity, the company should accept the order if:', '["The special price is higher than the normal selling price", "Incremental revenues are greater than incremental costs", "Total revenues exceed total fixed costs", "The order uses all remaining capacity"]'::jsonb, 1, 'In situations of spare capacity, if incremental revenues are greater than incremental costs, the order should be accepted on financial grounds. Allocated fixed costs should not be included.', 'Lecture 7', 62);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'In a make or buy decision, which cost is typically irrelevant?', '["Direct materials cost", "Direct labor cost", "Variable manufacturing overhead", "Fixed manufacturing overhead that will continue regardless of the decision"]'::jsonb, 3, 'Fixed manufacturing overhead that will be incurred regardless of whether the company makes or buys is irrelevant (a sunk/unavoidable cost). Only avoidable costs should be considered.', 'Lecture 7', 63);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company can make a part for $25 in variable costs per unit. Fixed overhead allocated to the part is $5 per unit but will continue even if the part is outsourced. An external supplier offers the part at $28. The company should:', '["Buy from the supplier because $28 < $30 total cost", "Continue to manufacture because the relevant cost ($25) is less than the supplier price ($28)", "Buy from the supplier to free up capacity", "The decision cannot be made without more information"]'::jsonb, 1, 'The relevant cost for manufacturing is $25 per unit (variable costs only), since the $5 fixed overhead is unavoidable. Since $25 < $28, the company should continue to manufacture.', 'Lecture 7', 64);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Activity-Based Costing (ABC) allocates overhead to:', '["A single cost pool using one cost driver", "Multiple activity cost pools and assigns them using cost drivers", "Products based solely on direct labor hours", "Products based solely on machine hours"]'::jsonb, 1, 'ABC allocates overhead to multiple activity cost pools and assigns the activity cost pools to products or services by means of cost drivers.', 'Lecture 8', 65);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'In ABC, an activity is defined as:', '["Any event, action, transaction, or work sequence that incurs cost when producing a product", "Only the direct manufacturing process", "The administrative functions of the company", "The sales and marketing process"]'::jsonb, 0, 'In activity-based costing, an activity is any event, action, transaction, or work sequence that incurs costs when producing a product or performing a service.', 'Lecture 8', 66);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A cost allocation base in ABC is preferably a:', '["Fixed cost", "Period cost", "Cost driver", "Sunk cost"]'::jsonb, 2, 'A cost allocation base is some factor or variable that allows us to allocate costs in a cost pool to cost objects. Preferably, it should be a cost driver — an activity that causes a cost to be incurred.', 'Lecture 8', 67);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The four steps in applying ABC are: (1) Identify activities and assign overhead to cost pools, (2) Identify cost drivers, (3) ?, (4) Assign overhead costs to products. What is step 3?', '["Calculate total fixed costs", "Compute the activity-based overhead rate for each cost pool", "Determine the selling price", "Prepare the income statement"]'::jsonb, 1, 'Step 3 is to compute the activity-based overhead rate for each cost pool: Estimated Overhead per Activity ÷ Expected Use of Cost Drivers.', 'Lecture 8', 68);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which of the following is TRUE about a traditional costing system?', '["It uses multiple overhead rates based on various cost drivers", "It allocates overhead using a single predetermined rate", "It is more accurate than ABC for companies with diverse products", "It is more expensive to implement than ABC"]'::jsonb, 1, 'A traditional costing system typically allocates overhead using a single predetermined rate (such as direct labor hours), unlike ABC which uses multiple cost pools and drivers.', 'Lecture 8', 69);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The four levels of activities in ABC are:', '["Unit-level, batch-level, product-level, and facility-level", "Direct, indirect, fixed, and variable", "Manufacturing, selling, administrative, and financing", "Short-term, medium-term, long-term, and permanent"]'::jsonb, 0, 'ABC classifies activities into four levels: unit-level activities, batch-level activities, product-level activities, and facility-level activities.', 'Lecture 8', 70);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which is a limitation of Activity-Based Costing?', '["It provides less accurate product costing than traditional methods", "It is expensive to use and more complex than traditional systems", "It uses only one cost pool", "It cannot be applied to manufacturing companies"]'::jsonb, 1, 'ABC limitations include being expensive to use, data collection challenges, and being more complex than traditional systems.', 'Lecture 8', 71);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A plantwide overhead rate uses:', '["Multiple cost pools with separate cost drivers for each", "One cost pool with all overhead costs and a single cost driver", "No cost driver at all", "Only variable costs in the allocation"]'::jsonb, 1, 'A plantwide rate places all overheads in one large cost pool and uses a single cost driver to allocate overheads to products.', 'Lecture 8', 72);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Budgeting is the process of:', '["Recording past financial transactions", "Creating a plan to allocate financial resources over a specific period", "Calculating the company''s tax obligations", "Conducting external audits"]'::jsonb, 1, 'Budgeting is the process of creating a plan to allocate financial resources over a specific period. It promotes efficiency and serves as a control device for performance evaluation.', 'Lecture 9', 73);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which of the following is NOT a benefit of budgeting?', '["Management can plan ahead", "An early warning system is provided for potential problems", "It enables disciplinary action to be taken at every level of responsibility", "The coordination of activities is facilitated"]'::jsonb, 2, 'Enabling disciplinary action at every level is NOT a benefit of budgeting. Benefits include planning ahead, providing early warning, facilitating coordination, and motivating personnel.', 'Lecture 9', 74);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The master budget contains two classes of budgets:', '["Cash budgets and capital budgets", "Operating budgets and financial budgets", "Sales budgets and production budgets", "Fixed budgets and flexible budgets"]'::jsonb, 1, 'The master budget contains two classes: operating budgets (resulting in the budgeted income statement) and financial budgets (capital expenditures budget, cash budget, and budgeted balance sheet).', 'Lecture 9', 75);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which budget is always prepared first?', '["Production budget", "Direct materials budget", "Sales budget", "Cash budget"]'::jsonb, 2, 'The sales budget is the first budget prepared. It is derived from the sales forecast, and every other budget depends on it.', 'Lecture 9', 76);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The production budget formula is:', '["Budgeted Sales + Desired Ending Inventory − Beginning Inventory = Required Production", "Budgeted Sales × Selling Price = Required Production", "Direct Materials + Direct Labor = Required Production", "Total Revenue − Total Costs = Required Production"]'::jsonb, 0, 'Required Production Units = Budgeted Sales Units + Desired Ending Finished Goods Units − Beginning Finished Goods Units.', 'Lecture 9', 77);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company expects to sell 5,000 units. It wants ending inventory of 800 units and has beginning inventory of 600 units. Required production is:', '["5,000 units", "5,200 units", "5,800 units", "4,800 units"]'::jsonb, 1, 'Required Production = 5,000 + 800 − 600 = 5,200 units.', 'Lecture 9', 78);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Participative budgeting means that:', '["Only top management prepares the budget", "Each level of management is invited to participate in the budgeting process", "Budgets are prepared by external auditors", "The government sets the company''s budget"]'::jsonb, 1, 'Participative budgeting means each level of management should be invited to participate. It can produce more accurate estimates but may also foster budgetary slack.', 'Lecture 9', 79);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A disadvantage of participative budgeting is:', '["It leads to less accurate budget estimates", "It can foster budgetary ''gaming'' through budgetary slack", "Lower-level managers are excluded from the process", "It is faster and cheaper than top-down budgeting"]'::jsonb, 1, 'A disadvantage of participative budgeting is that it can foster budgetary ''gaming'' through budgetary slack. It can also be time consuming and costly.', 'Lecture 9', 80);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The direct labor budget shows:', '["Only the quantity of labor hours needed", "Only the cost of direct labor", "Both the quantity of hours and cost of direct labor necessary to meet production requirements", "The cost of all employees in the company"]'::jsonb, 2, 'The direct labor budget shows both the quantity of hours and cost of direct labor necessary to meet production requirements. Total Direct Labor Cost = Units to Be Produced × Direct Labor Hours per Unit × Direct Labor Cost per Hour.', 'Lecture 10', 81);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company plans to produce 4,000 units. Each unit requires 1.5 hours of direct labor at $14 per hour. What is the total direct labor cost?', '["$56,000", "$84,000", "$21,000", "$42,000"]'::jsonb, 1, 'Total Direct Labor Cost = 4,000 × 1.5 × $14 = $84,000.', 'Lecture 10', 82);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The manufacturing overhead budget distinguishes between:', '["Direct and indirect materials", "Fixed and variable overhead costs", "Product and period costs", "Operating and financial budgets"]'::jsonb, 1, 'The manufacturing overhead budget shows expected manufacturing overhead costs and distinguishes between fixed and variable overhead costs.', 'Lecture 10', 83);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The selling and administrative expense budget includes:', '["Only manufacturing-related costs", "Costs related to selling products and managing the company, excluding production costs", "Only variable costs", "Only fixed costs"]'::jsonb, 1, 'The selling and administrative expense budget projects anticipated operating expenses related to selling products and managing the business, excluding manufacturing costs. It distinguishes between fixed and variable costs.', 'Lecture 10', 84);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Each of the following budgets is used in preparing the budgeted income statement EXCEPT the:', '["Sales budget", "Selling and administrative budget", "Capital expenditure budget", "Direct labor budget"]'::jsonb, 2, 'The capital expenditure budget is a financial budget, not an operating budget. The budgeted income statement is prepared from operating budgets: sales, direct materials, direct labor, manufacturing overhead, and selling & administrative expense budgets.', 'Lecture 10', 85);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The cash budget contains which three sections?', '["Assets, liabilities, and equity", "Revenue, expenses, and profit", "Cash receipts, cash disbursements, and financing", "Operating, investing, and financing"]'::jsonb, 2, 'The cash budget contains three sections: cash receipts, cash disbursements, and financing. It shows beginning and ending cash balances.', 'Lecture 10', 86);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A company has a beginning cash balance of $16,500, expected cash receipts of $210,000, and expected disbursements of $220,000. If the minimum desired balance is $15,000, how much must be borrowed?', '["$0", "$6,500", "$8,500", "$15,000"]'::jsonb, 2, 'Available cash = $16,500 + $210,000 = $226,500. After disbursements: $226,500 − $220,000 = $6,500. To reach minimum $15,000: need to borrow $15,000 − $6,500 = $8,500.', 'Lecture 10', 87);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Expected direct materials purchases are $70,000 in Q1 and $90,000 in Q2. If 40% is paid in cash as incurred and the balance in the following quarter, what are the budgeted cash payments for purchases in Q2?', '["$96,000", "$90,000", "$78,000", "$72,000"]'::jsonb, 2, 'Q2 payments = 40% of Q2 purchases ($90,000 × 0.40 = $36,000) + 60% of Q1 purchases ($70,000 × 0.60 = $42,000) = $36,000 + $42,000 = $78,000.', 'Lecture 10', 88);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The budgeted balance sheet is:', '["A projection of financial position at the end of the budget period", "A record of all past transactions", "A list of all budgets prepared during the year", "The same as the cash budget"]'::jsonb, 0, 'The budgeted balance sheet is a projection of financial position at the end of the budget period. It is developed from the budgeted balance sheet for the preceding year and budgets for the current year.', 'Lecture 10', 89);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A budgeted income statement is important because it:', '["Shows the company''s cash position", "Indicates expected profitability of operations and provides a basis for evaluating company performance", "Lists all the company''s assets and liabilities", "Is required before preparing the sales budget"]'::jsonb, 1, 'The budgeted income statement is an important end-product of operating budgets. It indicates expected profitability of operations and provides a basis for evaluating company performance.', 'Lecture 10', 90);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Strategic objectives are best described as:', '["Short-term daily operational tasks", "Specific, measurable goals that translate an organization''s mission and vision into action", "Financial accounting standards", "The company''s advertising campaigns"]'::jsonb, 1, 'Strategic objectives are the specific, measurable goals an organization sets to translate its mission and vision into action. They serve as the foundation for performance measurement and resource allocation.', 'Lecture 11', 91);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'The Balanced Scorecard was launched in 1992 by:', '["Peter Drucker and Michael Porter", "Robert Kaplan and David Norton", "Warren Buffett and Charlie Munger", "Frederick Taylor and Henri Fayol"]'::jsonb, 1, 'The Balanced Scorecard was launched in 1992 by Robert Kaplan and David Norton.', 'Lecture 11', 92);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'In the O/CPV (OVAR) method, Critical Performance Variables (CPVs) are:', '["Financial ratios used only in annual reports", "Indicators of how to support strategic goals, limited in number (usually 3 to 5) and tightly linked to strategic priorities", "The total number of employees in each department", "The company''s stock price over time"]'::jsonb, 1, 'CPVs indicate how to support strategic goals. They are limited in number (usually 3 to 5 per unit or role) and tightly linked to strategic priorities.', 'Lecture 11', 93);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Key Performance Indicators (KPIs) are:', '["Broad organizational missions", "Specific, measurable metrics used to evaluate how effectively an organization is achieving its strategic objectives", "Only financial ratios", "Government regulations for businesses"]'::jsonb, 1, 'KPIs are specific, measurable metrics used to evaluate how effectively an individual, team, or organization is achieving its strategic objectives. They act as bridges between strategy and day-to-day operations.', 'Lecture 11', 94);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A dashboard in management control is:', '["A physical control panel in a factory", "A graphical user interface providing at-a-glance views of KPIs relevant to a particular objective", "A type of financial statement", "A budgeting software"]'::jsonb, 1, 'A dashboard is a type of graphical user interface which often provides at-a-glance views of key performance indicators (KPIs) relevant to a particular objective or business process. It includes financial and non-financial indicators.', 'Lecture 11', 95);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'In the management control structure, the upstream phase includes:', '["Variance analysis and corrective decisions", "Objectives, action plans, and resource allocation", "Only financial reporting", "External auditing"]'::jsonb, 1, 'The upstream phase includes objectives, action plans, and resource allocation. The downstream phase includes variance analysis, corrective decisions, forecasts, and budgeting.', 'Lecture 11', 96);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'According to the course, why do large organizations need formal management control systems?', '["Because they have fewer employees", "Because power to make decisions is shared with lower-level managers, requiring formal control practices", "Because they only operate in one country", "Because they have no strategic objectives"]'::jsonb, 1, 'Large organizations need formal control practices such as budgets, performance measures, and reward systems because power to make decisions is shared with lower-level managers.', 'Lecture 11', 97);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'A sales forecast:', '["Shows potential sales for the industry and a company''s expected share of such sales", "Is the same as the production budget", "Lists all fixed costs", "Is prepared after all other budgets"]'::jsonb, 0, 'A sales forecast shows potential sales for the industry and a company''s expected share of such sales. It forms the basis for developing the budget.', 'Lecture 11', 98);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Financial budgets focus primarily on:', '["The profitability of each product line", "The cash resources needed to fund expected operations and planned capital expenditures", "Employee performance evaluation", "Marketing strategy"]'::jsonb, 1, 'Financial budgets focus primarily on the cash resources needed to fund expected operations and planned capital expenditures.', 'Lecture 11', 99);

  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_full_quiz_id, 'Which of the following best describes the relationship between mission, vision, and strategic objectives?', '["They are all the same concept", "Mission defines why the organization exists, vision defines what it aspires to become, and strategic objectives are specific targets aligned with both", "Strategic objectives come first, then mission, then vision", "Vision is for daily operations while mission is for long-term planning"]'::jsonb, 1, 'Mission defines why the organization exists (its core purpose and values), vision defines what the organization aspires to become in the future, and strategic objectives are specific targets aligned with mission and vision.', 'Lecture 11', 100);

END $$;