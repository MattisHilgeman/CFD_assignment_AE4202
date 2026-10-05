import numpy as np

# Read text-based numeric data
x, y = np.loadtxt("guide_vane.dat", unpack=True)



with open("assignment.geo", "w") as file:
    
    # Write first point
    file.write(f"Point(1) = {{{x[0]}, {y[0]}, 0, 1.0}};\n //+ \n")
    
    # Loop over additional points and write them to the .dat file. 
    # Connect the newly written point to the previous one
    for i in range(1, len(x)):
        file.write(f"Point({i+1}) = {{{x[i]}, {y[i]}, 0, 1.0}};\n //+ \n")
        file.write(f"Line({i}) = {{{i}, {i+1}}};\n //+ \n")
        
    file.write(f"Line({len(x)}) = {{1, {len(x)}}};\n //+ \n")
        
            

