package com.example.controller;

import com.example.dto.contract.ContractDetailDto;
import com.example.dto.contract.ShowContractDto;
import com.example.model.contract.*;
import com.example.model.customer.Customer;
import com.example.model.employee.Employee;
import com.example.model.facility.Facility;
import com.example.service.contract.IAttachFacilityService;
import com.example.service.contract.IContractDetailService;
import com.example.service.contract.IContractService;
import com.example.service.customer.ICustomerService;
import com.example.service.employee.IEmployeeService;
import com.example.service.facility.IFacilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping(value = "/contract")
public class ContractController {

    @Autowired
    private IContractService contractService;

    @Autowired
    private IContractDetailService contractDetailService;

    @Autowired
    private IAttachFacilityService attachFacilityService;

    @Autowired
    private ICustomerService customerService;

    @Autowired
    private IEmployeeService employeeService;

    @Autowired
    private IFacilityService facilityService;

    @GetMapping(value = "/show-list")
    public String displayContractList(Model model, Pageable pageable) {
        List<Customer> customerList = customerService.getAllCustomer();
        ContractDetailDto contractDetailDto = new ContractDetailDto();
        Page<ShowContractDto> contractPage = contractService.getAllContractDto(pageable);
        List<AttachFacility> attachFacilityList = attachFacilityService.getAllAttachFacility();
        List<Facility> facilityList = facilityService.getAllFacility();
        List<Employee> employeeList = employeeService.getAllEmployee();
        ContractDetail contractDetail = new ContractDetail();
        model.addAttribute("attachFacilityList", attachFacilityList);
        model.addAttribute("facilityList", facilityList);
        model.addAttribute("employeeList", employeeList);
        model.addAttribute("contractDetailDto", contractDetailDto);
        model.addAttribute("contractDetail", contractDetail);
        model.addAttribute("contractPage", contractPage);
        model.addAttribute("customerList", customerList);
        return "/contract/list";
    }

    @PostMapping("/add-attach-facility")
    public String addDetailContract(@ModelAttribute("contractDetail") ContractDetail contractDetail, RedirectAttributes redirectAttributes) {
        boolean check = contractDetailService.addContractDetail(contractDetail);
        String mess;
        if (check) {
            mess = "Đã thêm mới dịch vụ đi kèm thành công";
        } else {
            mess = "Đã xảy ra lỗi";
        }
        redirectAttributes.addFlashAttribute("mess", mess);
        return "redirect:/contract/show-list";
    }


}
