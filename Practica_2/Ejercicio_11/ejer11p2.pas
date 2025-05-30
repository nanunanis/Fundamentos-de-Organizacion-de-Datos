{
Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:


Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____


Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.

}


program Ejercicio11;
const
	valor = 9999;
type
	empleado = record
		departamento: integer;
		division: integer;
		num_empleado: integer;
		categoria: integer;
		horas: integer;
	end;
	
	maestro = file of empleado;
	
	valor_categoria = array[1..15] of real;
	
procedure leer(var m:maestro; var e:empleado);
begin
	if(not EOF(m))then
		read(m,e)
	else
		e.departamento:= valor;
end;

procedure cargar(var c:valor_categoria);
var
	cat: integer;
	monto: real;
	arc: text;
begin
	assign(arc, 'Categoria.txt');
	reset(arc);
	while(not EOF(arc))do begin
		read(arc, cat, monto);
		c[cat]:= monto;
	end;
	close(arc);
end;

procedure informe(var m: maestro; c: valor_categoria);
var
	e:empleado;
	hsD, hsE, totalH, depa, dv, numEmp: integer;
	montoD, montoE, totalM:real;
begin
	reset(m);
	leer(m,e);
	while(e.departamento <> valor)do begin
		depa:= e.departamento;
		writeln('Departamento: ', depa);
		totalM:=0;
		totalH:=0;
		while((e.departamento <> valor) and (e.departamento = depa))do begin
			dv:= e.division;
			writeln('Division: ', dv);
			hsD:= 0;
			montoD:=0;
			writeln('Numero de empleado     Total de Hs     Importe a cobrar');
			while((e.departamento <> valor) and (e.departamento = depa) and (e.division = dv))do begin
				numEmp:= e.num_empleado;
				hsE:= 0;
				montoE:=0;
				while((e.departamento <> valor) and (e.departamento = depa) and (e.division = dv) and (e.num_empleado = numEmp))do begin
					hsE:= hsE + e.horas;
					montoE:= montoE + (e.horas * c[e.categoria]);
					leer(m,e);
				end;
				writeln(numEmp, '               ', hsE,'               ',montoE:0:2);  // dudo que esto se vea bien en la impresion, ojala fuera python
				hsD:=hsD + hsE;
				montoD:= montoD + montoE;
			end;
			writeln('Total de horas division: ', hsD);
			writeln('Monto total por division: ', montoD:0:2);
			totalH:= totalH + hsD;
			totalM:= totalM + montoD;
			writeln;
		end;
		writeln('Total horas departamento: ', totalH);
		writeln('Monto total departamento: ', totalM:0:2);
		writeln;
	end;
	close(m);
end;
	
var
	m:maestro;
	c:valor_categoria;
begin
	assign(m, 'Maestro');
	cargar(c);
	informe(m, c);
end.
