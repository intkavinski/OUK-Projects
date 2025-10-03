import from byllm { Model }

glob llm = Model(model_name="gemini/gemini-2.5-flash");

walker currency_converter {
    can start {  // Changed from can start entry {
        root {
            start {
                print("Jac walker is working fine")
            }
        }
    }
}