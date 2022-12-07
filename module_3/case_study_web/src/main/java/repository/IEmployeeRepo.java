package repository;

import model.employee.Division;
import model.employee.EducationDegree;
import model.employee.Employee;
import model.employee.Position;

import java.util.List;

public interface IEmployeeRepo {
    List<Division> getAllDivision();
    List<Position> getAllPosition();
    List<EducationDegree> getAllEducationDegree();
    List<Employee> getAllEmployee();
    boolean addEmployee(Employee employee);
}
