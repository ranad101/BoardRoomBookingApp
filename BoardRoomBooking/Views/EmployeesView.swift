import SwiftUI

struct EmployeesView: View {
    var onLogin: (String) -> Void  // Closure to pass the logged-in employee ID
    @State private var jobNumber = ""  // User-input job number
    @State private var password = ""  // User-input password
    @State private var loginFailed = false  // Flag for login failure
    @State private var isPasswordVisible = false  // Toggle password visibility
    @StateObject private var viewModel = EmployeesViewModel()  // Fetch employees

    var body: some View {
        VStack(spacing: 20) {
            // Welcome Text
            Text("Welcome back! Glad to see you, Again!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            // Job Number Input
            TextField("Enter your job number", text: $jobNumber)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)

            // Password Input
            HStack {
                if isPasswordVisible {
                    TextField("Enter your password", text: $password)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField("Enter your password", text: $password)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }

                // Eye Button
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)

            // Login Button
            Button(action: {
                login()
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            // Login Error Message
            if loginFailed {
                Text("Invalid job number or password")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .onAppear {
            viewModel.loadEmployees()  // Fetch employees when the screen appears
        }
    }

    // Login Logic
    private func login() {
        guard let employee = viewModel.employees.first(where: {
            String($0.id) == jobNumber && $0.password == password
        }) else {
            loginFailed = true
            return
        }

        print("Login successful for employee: \(employee.name)")
        onLogin(jobNumber)  // Pass the logged-in employee's job number to ContentView
    }
}
