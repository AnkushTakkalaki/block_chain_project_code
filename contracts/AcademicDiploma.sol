// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AcademicDiploma {
    struct Diploma {
        string studentName;
        string degree;
        string institutionName;
        string graduationDate;
        string qrCode;
        bool isIssued;
    }

    mapping(bytes32 => Diploma) private diplomas;
    address private owner;

    event DiplomaIssued(bytes32 indexed diplomaId, string studentName, string degree, string institutionName, string graduationDate, string qrCode);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function issueDiploma(string memory studentName, string memory degree, string memory institutionName, string memory graduationDate, string memory qrCode) public onlyOwner returns (bytes32) {
        bytes32 diplomaId = keccak256(abi.encodePacked(studentName, degree, institutionName, graduationDate, qrCode));
        require(!diplomas[diplomaId].isIssued, "Diploma already issued");

        diplomas[diplomaId] = Diploma({
            studentName: studentName,
            degree: degree,
            institutionName: institutionName,
            graduationDate: graduationDate,
            qrCode: qrCode,
            isIssued: true
        });

        emit DiplomaIssued(diplomaId, studentName, degree, institutionName, graduationDate, qrCode);
        return diplomaId;
    }

    function verifyDiploma(bytes32 diplomaId) public view returns (bool) {
        return diplomas[diplomaId].isIssued;
    }

    function getDiplomaDetails(bytes32 diplomaId) public view returns (string memory, string memory, string memory, string memory, string memory) {
        require(diplomas[diplomaId].isIssued, "Diploma not found");
        Diploma memory diploma = diplomas[diplomaId];
        return (diploma.studentName, diploma.degree, diploma.institutionName, diploma.graduationDate, diploma.qrCode);
    }
}
