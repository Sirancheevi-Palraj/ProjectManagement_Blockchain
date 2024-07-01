// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract TaskMaster {
    address[] TaskOwners;
    struct TaskInformation {
        bytes ProjectID;
        bytes Taskname;
        bytes Description;
        int256 Priority;
        bytes ResourceDetails;
        int256 Status;
        bytes Remarks;
    }
    mapping(string => TaskInformation) public TaskDetails;
    uint256 TaskCount = 0;

    constructor(address _admin) {
        TaskOwners[0] = _admin;
    }

    modifier isEligible(address _add) {
        require(isTaskOwnerExists(_add), "You are not authorized");
        _;
    }

    function CreateTask(
        bytes memory ProjectID,
        bytes memory Taskname,
        int256 Priority,
        bytes memory Description,
        bytes memory ResourceDetails,
        int256 Status,
        bytes memory Remarks
    )
        public
        isEligible(msg.sender)
        returns (bool result, string memory Message)
    {
        TaskInformation memory TaskInformationObj = TaskInformation({
            ProjectID: ProjectID,
            Taskname: Taskname,
            Description: Description,
            Priority: Priority,
            ResourceDetails: ResourceDetails,
            Status: Status,
            Remarks: Remarks
        });
        TaskCount++;
        string memory TaskID = uintToStringWithZeroPadding(TaskCount, 10);
        TaskDetails[TaskID] = TaskInformationObj;
        result = true;
        Message = TaskID;
    }
    function UpdateTask(
        bytes memory ProjectID,
        bytes memory Taskname,
        int256 Priority,
        bytes memory Description,
        bytes memory ResourceDetails,
        int256 Status,
        bytes memory Remarks,
        string memory TaskID
    )
        public
        isEligible(msg.sender)
        returns (bool result, string memory Message)
    {
        TaskInformation memory TaskInformationObj = TaskInformation({
            ProjectID: ProjectID,
            Taskname: Taskname,
            Description: Description,
            Priority: Priority,
            ResourceDetails: ResourceDetails,
            Status: Status,
            Remarks: Remarks
        });
        TaskDetails[TaskID] = TaskInformationObj;
        result = true;
        Message = "Updated Successfully";
    }
function GetTask(string memory TaskID)
        public
        isEligible(msg.sender)
        view
        returns (
             string memory ProjectID,
        string memory Taskname,
        int256 Priority,
        string memory Description,
        string memory ResourceDetails,
        int256 Status,
        string memory Remarks,
        bool result, string memory Message
        )
    {
        TaskInformation memory TaskInformationObj = TaskDetails[
            TaskID
        ];
        if (TaskInformationObj.Taskname.length > 0) {
            ProjectID = string(TaskInformationObj.ProjectID);
            Taskname = string(TaskInformationObj.Taskname);
            Priority = TaskInformationObj.Priority;
            Description = string(TaskInformationObj.Description);
            Status = TaskInformationObj.Status;
            Remarks = string(TaskInformationObj.Remarks);
            ResourceDetails = string(TaskInformationObj.ResourceDetails);
            result = true;
        } else {
            result = true;
            Message = "No Data Found";
        }
    }
    //Utility functions
    function uintToStringWithZeroPadding(uint256 value, uint256 length)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(length);
        for (uint256 i = length; i > 0; i--) {
            buffer[i - 1] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function isTaskOwnerExists(address _address) public view returns (bool) {
        for (uint256 i = 0; i < TaskOwners.length; i++) {
            if (TaskOwners[i] == _address) {
                return true;
            }
        }
        return false;
    }
}
