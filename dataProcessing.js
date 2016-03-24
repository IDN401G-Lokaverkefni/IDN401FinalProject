
// Fetch data to be processed
var dataFile = require("./dataFile.js");

// Import data
dataMatrixWithConstraints = dataFile.dataMatrixWithConstraints;
dataMatrixWithoutSeats = dataFile.dataMatrixWithoutSeats;
dataMatrixUniversity = dataFile.dataMatrixUniversity;
dataMatrixRestEPlusTwo = dataFile.dataMatrixRestEPlusTwo;
dataMatrixRestEPlusThree = dataFile.dataMatrixRestEPlusThree;
dataMatrixRestEPlusFour = dataFile.dataMatrixRestEPlusFour;
dataMatrixStudents = dataFile.dataMatrixStudents;
groupArray = dataFile.groupArray;

// Function to calculate how many rest days a group receives on average. Takes
// the group, which exam setup is to be used (dataMatrix) and a boolean value
// (addPrecedingDays) to tell whether days/slots before the first exam are to
// be calculated as rest days or not.
// Returns array[2] with average amount of rest in slots (first value) and
// average amount of rest in days (second value) for the group.
var processGroup = function(group, dataMatrix, addPrecedingDays){
  // Function variables for calculations
  var restDataArray = [];
  var restDataArrayInDays = [];
  var restSumInSlots = 0;
  var restSumInDays = 0;
  // Add slots, where group has to take exams, to restDataArray
  for(g in group){
    for(d in dataMatrix[1]){
      if(dataMatrix[1][d].localeCompare(group[g]) === 0){
        restDataArray.push(dataMatrix[2][d]);
      }
    };
  };
  // Add first days/slots into calculations if necessary
  if(addPrecedingDays){
    restDataArray.push(0);
  }
  // Sort restDataArray in ascending order
  restDataArray.sort(function(x,y){return x-y});
  // Convert data to days in stead of slots
  restDataArrayInDays = restDataArray.map(function(x){return Math.ceil(x/2)});
  // Calculate average amount of rest that each group receives
  for(var r = 0; r < restDataArray.length - 1; r++){
    restSumInSlots += restDataArray[r+1] - restDataArray[r] - 1;
    if(restDataArrayInDays[r+1] - restDataArrayInDays[r] > 0){
      restSumInDays += restDataArrayInDays[r+1] - restDataArrayInDays[r] - 1;
    }
  }
  // Divide by amount of periods that are between exams
  if(restDataArray.length !== 1){
    restSumInSlots = restSumInSlots/(restDataArray.length - 1);
    restSumInDays = restSumInDays/(restDataArrayInDays.length - 1);
  }
  return [restSumInSlots, restSumInDays];
};

// Function for processing each exam table setup. Takes an array with the
// courses each group takes (groups), the exam table (dataMatrix), and
// a boolean value (addPrecedingDays) to determine whether the days/slots
// preceding the first exam should be calculated as rest periods.
// Prints outcomes to console.
var processDataMatrix = function(groups, dataMatrix, addPrecedingDays){
  totalSumInSlots = 0;
  totalSumInDays = 0;
  for(g in groups){
    groupResult = processGroup(groups[g], dataMatrix, addPrecedingDays);
    totalSumInSlots += groupResult[0];
    totalSumInDays += groupResult[1];
  }
  avgSlots = totalSumInSlots/groups.length;
  avgDays = totalSumInDays/groups.length;
  if(addPrecedingDays){
    console.log("Preceding days added: ");
  }
  else{
    console.log("Preceding days not added: ");
  }
  console.log("Average amount of rest in slots for groups: " + avgSlots);
  console.log("Average amount of rest in days for groups: " + avgDays);
};

console.log("Data with 3 basic constraints: ");
processDataMatrix(groupArray, dataMatrixWithConstraints, false);
processDataMatrix(groupArray, dataMatrixWithConstraints, true);
console.log("--------------------------------------------------------------");
console.log("Data without seat constraint: ");
processDataMatrix(groupArray, dataMatrixWithoutSeats, false);
processDataMatrix(groupArray, dataMatrixWithoutSeats, true);
console.log("--------------------------------------------------------------");
console.log("Data from University");
processDataMatrix(groupArray, dataMatrixUniversity, false);
processDataMatrix(groupArray, dataMatrixUniversity, true);
console.log("--------------------------------------------------------------");
console.log("Data with rest e+2");
processDataMatrix(groupArray, dataMatrixRestEPlusTwo, false);
processDataMatrix(groupArray, dataMatrixRestEPlusTwo, true);
console.log("--------------------------------------------------------------");
console.log("Data with rest e+3");
processDataMatrix(groupArray, dataMatrixRestEPlusThree, false);
processDataMatrix(groupArray, dataMatrixRestEPlusThree, true);
console.log("--------------------------------------------------------------");
console.log("Data with rest e+4");
processDataMatrix(groupArray, dataMatrixRestEPlusFour, false);
processDataMatrix(groupArray, dataMatrixRestEPlusFour, true);
console.log("--------------------------------------------------------------");
console.log("Data with greater number of students earlier");
processDataMatrix(groupArray, dataMatrixStudents, false);
processDataMatrix(groupArray, dataMatrixStudents, true);
