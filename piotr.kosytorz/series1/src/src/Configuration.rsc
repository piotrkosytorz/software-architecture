module Configuration

// The URI address where the application is to be served
public loc serveAddress = |http://localhost:5433|;

// The rascal location of the Project
public loc projectLocation = |project://piotr-series1|;

// Rascal locations of the eclipse projects to be analyzed
public loc testProject = |project://JavaTestProject|;
public loc smallSqlProject = |project://smallsql0.21_src|;
public loc hqSqlProject = |project://src/org/hsqldb|;