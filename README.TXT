Executing `src/destroy-and-rebuild-all` will create all of the html files, the knowls folder, printdraft.tex, printcolordraft.tex, and screenpdfdraft.tex.

Executing `src/compileall` will run xelatex twice on the above three .tex files, giving pdfs.

Everything in the images folder comes with the distribution, and is referenced by the html files and knowls. If you modify source for an image, or if you insert or remove images (thus changing their reference ids), you will need to re-create the images. To do that, run `mathbook/script/mbx -c latex-image -f all -d <full path to src/images> <full path to src/clm.xml>`. Also, the few images that have gradient shading need special treatment for their svg, png, and eps versions to come out right. For them, find their .tex files in the images folder. Edit them to remove the (unnecessary) xparse and xltxtra packages. Then compile with pdflatex. Then convert the resulting pdf to svg, png, and eps formats.
