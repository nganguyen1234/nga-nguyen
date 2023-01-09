package com.example.service.impl;

import com.example.model.contract.Contract;
import com.example.dto.contract.ShowContractDto;
import com.example.repository.contract.IContractRepository;
import com.example.service.contract.IContractService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.OptimisticLockingFailureException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class ContractService implements IContractService {
    @Autowired
    private IContractRepository contractRepository;

    @Override
    public List<Contract> getAllContracts() {
        return contractRepository.findAll();
    }

    @Override
    public Page<Contract> getAllContracts(Pageable pageable) {
        return contractRepository.getAllContract(pageable);
    }

    @Override
    public Page<ShowContractDto> getAllContractDto(Pageable pageable) {
        List<ShowContractDto> contractDtoList = new ArrayList<>();
        List<Contract> contractList = contractRepository.findAll();
        for (Contract ct : contractList) {
            ShowContractDto contractDto = new ShowContractDto();
            BeanUtils.copyProperties(ct, contractDto);
            contractDto.setTotal(contractRepository.calculateTotal(ct.getId()));
            contractDtoList.add(contractDto);
        }
        return new PageImpl<>(contractDtoList);
    }

    @Override
    public boolean addContract(Contract contract) {
        if (isExist(contract)) {
            return false;
        }
        try {
            contractRepository.save(contract);
        } catch (
                IllegalArgumentException | OptimisticLockingFailureException e) {
            return false;
        }
        return true;
    }

    @Override
    public boolean isExist(Contract contract) {
        List<Contract> contractList = getAllContracts();
        for (Contract ct : contractList) {
            if (Objects.equals(ct.getId(), contract.getId())) {
                return true;
            }
        }
        return false;
    }
}
