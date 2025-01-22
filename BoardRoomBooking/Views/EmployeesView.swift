import SwiftUI

struct EmployeesView: View {
    @StateObject private var viewModel = EmployeesViewModel()

    var body: some View {
        List(viewModel.employees, id: \.id) { employee in
            VStack(alignment: .leading, spacing: 8) {
                Text("Name: \(employee.name)")
                    .font(.headline)
                Text("Job Title: \(employee.jobTitle)")
                    .font(.subheadline)
                Text("Email: \(employee.email)")
                    .font(.body)
                Text("Password: \(employee.password)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            viewModel.loadEmployees()
        }
        .navigationTitle("Employees")
    }
}
