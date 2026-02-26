# retroki625
perl script to backport v6 to v5 kicad parts

ugh,so for *reasons* I'm stuck with kicad v5 for a while,

buiding all the components I need every time I want to make a pcb is really a pain,so I started this perl script to help me backport v6 part files (.kicad_sym) to v5 files (.lib) soon I may have to start one to backport v7 files, whatever.

THIS IS NOT FINISHED, but the output, with a bit of hand editing, works. 

As I have more need of this program, I will keep working on it. For now, I have the CH32 microcontrollers I needed. 

ToDo:

- state machine to close draw and definition
- header and footers
- have state machine ignore inner 'symbol' decleration.
- finish the elsif blocks for polyline, circle, arc.
- have it automatically create the .def file too.
- output to an acual file, instead of stdout.
