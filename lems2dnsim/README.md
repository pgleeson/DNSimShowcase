Initial tests on converting LEMS/NeuroML2 to DNSim
==================================================

Java code for this is [here](https://github.com/NeuroML/org.neuroml.export/blob/development/src/main/java/org/neuroml/export/dnsim/DNSimWriter.java)
and this uses templates [here](https://github.com/NeuroML/org.neuroml.export/blob/development/src/main/resources/dnsim/dnsim.m.vm)
and [here](https://github.com/NeuroML/org.neuroml.export/blob/development/src/main/resources/dnsim/dnsim.txt.vm)

Initial example included has converted [this file](https://github.com/NeuroML/NeuroML2/blob/development/LEMSexamples/LEMS_NML2_Ex9_FN.xml)
which uses lems definition [here](https://github.com/NeuroML/NeuroML2/blob/master/NeuroML2CoreTypes/Cells.xml#L1133).
