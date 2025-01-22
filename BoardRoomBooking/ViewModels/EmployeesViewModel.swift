import Foundation

class EmployeesViewModel: ObservableObject {
    @Published var employees: [EmployeeFields] = []

    func loadEmployees() {
        NetworkManager.shared.fetchEmployees { [weak self] response in
            DispatchQueue.main.async {
                self?.employees = response?.records.map { $0.fields } ?? []
            }
        }
    }
}
