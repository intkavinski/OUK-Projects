"""A Currency Conversion Walker"""

import from byllm.llm { Model }

// Define global LLM model (can be removed if not using a live API call)
glob llm = Model(model_name="gemini/gemini-2.5-flash");

// Define fixed exchange rates as constants
const USD_TO_KES = 150.0;
const USD_TO_EUR = 0.92;

// --- Node Definitions ---
// Represents the application state
node app {
    has amount: float;
    has choice: int;
    has result: float = 0.0;
    has from_curr: str = "";
    has to_curr: str = "";
}

// --- Walker Definition ---
walker currency_converter {
    // Walker state (data carried by the walker)
    has amount: float = 0.0;
    has choice: int = 0;

    // Define the walker's state transitions
    can start with root entry;
    can get_input with app entry;
    can perform_conversion with app entry;
    can output_result with app entry; // New step for output
}

// --- Entry Point ---
# Will run when in CLI mode (not in cloud)
with entry:__main__ {
    // Start the walker on the root node
    root spawn currency_converter;
}

// --- Walker Implementations ---

// 1. Initial Start: Prompt the user and transition to the input step
impl currency_converter.start {
    print("====== Welcome to the Jac Currency Converter ======");
    // Create an application node and move the walker there
    next_node = root ++> app;
    visit next_node.get_input; // Transition to the get_input ability
}

// 2. Get Input: Collect the amount and the conversion choice
impl currency_converter.get_input {
    // Get amount
    print("Enter the amount to convert: ");
    self.amount = float(input());

    // Show conversion options
    print("\nChoose a conversion type:");
    print("1. USD to KES");
    print("2. KES to USD");
    print("3. USD to EUR");
    print("4. EUR to USD");
    print("Enter choice (1-4): ");
    
    // Get choice
    self.choice = int(input());

    // Update the app node with the collected data
    here.amount = self.amount;
    here.choice = self.choice;

    // Transition to the conversion step
    visit here.perform_conversion; 
}

// 3. Perform Conversion: Execute the selected conversion logic
impl currency_converter.perform_conversion {
    result = 0.0;
    from_curr = "";
    to_curr = "";
    valid_choice = true;

    if self.choice == 1 {
        result = self.amount * USD_TO_KES;
        from_curr = "USD";
        to_curr = "KES";
    } elif self.choice == 2 {
        result = self.amount / USD_TO_KES;
        from_curr = "KES";
        to_curr = "USD";
    } elif self.choice == 3 {
        result = self.amount * USD_TO_EUR;
        from_curr = "USD";
        to_curr = "EUR";
    } elif self.choice == 4 {
        result = self.amount / USD_TO_EUR;
        from_curr = "EUR";
        to_curr = "USD";
    } else {
        print("\nInvalid choice: ", self.choice, ". Please restart the application.");
        disengage; // Stop the walker for invalid input
        valid_choice = false;
    }

    if valid_choice {
        // Store results back in the node
        here.result = result;
        here.from_curr = from_curr;
        here.to_curr = to_curr;
        
        // Transition to the output step
        visit here.output_result;
    }
}

// 4. Output Result: Display the final calculation and complete the walk
impl currency_converter.output_result {
    // Retrieve data from the current node (here)
    print("\n------------------------------------------------");
    print(here.amount, here.from_curr, " = ", here.result, here.to_curr);
    print("------------------------------------------------");
    print("====== Conversion Complete ======");

    disengage; // Stop the walker after completing the task
}
