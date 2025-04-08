import ballerina/io;

public function main() {

    string[] names = ["Bob", "Jo", "Ann", "Tom"];
    // Loop through a list.
    foreach string name in names {
        io:println(name);
    }

    // Iterate a structure.
    map<int> grades = { Bob : 65, Jo : 70, Ann : 75, Tom : 60};
    int sum = 0;
    foreach int grade in grades {
      sum += grade;
    }

    io:println("Average :", sum/grades.length());

    // Binding patterns can be used with the `foreach` statement.
    // Values in `resultList` are assigned to `name`, `grade` variables in the binding pattern.
    [string, int][] resultList = [["Bob", 65], ["Jo", 70], ["Ann", 75], ["Tom", 60]];
    // Binding patterns (e.g., `[string, int]` and `[name, grade]`) are used with the `foreach` statement.
    foreach [string, int] [name, grade] in resultList {
        io:println("Name:", name, " ", "Grade:", grade);
    }

}
