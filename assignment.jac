
walker currency_converter {
    can enter {
        root {
            start {
                print("====== Welcome to the Jac Currency Converter ======")

                // Ask user for amount
                print("Enter the amount to convert: ")
                amount = float(input())

                // Show conversion options
                print("Choose a conversion type:")
                print("1. USD to KES")
                print("2. KES to USD")
                print("3. USD to EUR")
                print("4. EUR to USD")

                choice = int(input())

                // Define fixed exchange rates
                usd_to_kes = 150.0    // 1 USD = 150 KES
                usd_to_eur = 0.92     // 1 USD = 0.92 EUR

                if choice == 1 {
                    result = amount * usd_to_kes
                    print(amount, "USD = ", result, "KES")
                } elif choice == 2 {
                    result = amount / usd_to_kes
                    print(amount, "KES = ", result, "USD")
                } elif choice == 3 {
                    result = amount * usd_to_eur
                    print(amount, "USD = ", result, "EUR")
                } elif choice == 4 {
                    result = amount / usd_to_eur
                    print(amount, "EUR = ", result, "USD")
                } else {
                    print("Invalid choice. Please try again.")
                }

                print("====== Conversion Complete ======")
            }
        }
    }
}
