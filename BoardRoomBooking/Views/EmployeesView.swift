import SwiftUI

struct EmployeesView: View {
    var onLogin: (String) -> Void
    @State private var jobNumber = ""
    @State private var password = ""
    @State private var loginFailed = false
    @State private var isPasswordVisible = false
    @StateObject private var viewModel = EmployeesViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome back! Glad to see you, Again!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Enter your job number", text: $jobNumber)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            HStack {
                if isPasswordVisible {
                    TextField("Enter your password", text: $password)
                } else {
                    SecureField("Enter your password", text: $password)
                }
                
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            Button(action: { login() }) {
                Text("Log In")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            if loginFailed {
                Text("Invalid job number or password")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .onAppear {
            viewModel.loadEmployees()
        }
    }
    
    private func login() {
        guard let employee = viewModel.employees.first(where: {
            String($0.id) == jobNumber && $0.password == password
        }) else {
            loginFailed = true
            return
        }
        
        onLogin(jobNumber)
    }
}
