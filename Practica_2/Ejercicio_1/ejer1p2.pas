{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}


program ejer1p2;
type
	empleado = record
		cod: integer;
		nombre: string;
		monto: real;
	end;
	
	archivo = file of empleado;
	
procedure linea(); begin writeln('--------------------------'); end;

procedure crearArc(var arc: archivo; var arc_txt: text);
var
	e, empleados: empleado;
	monto: real;
begin
	assign(arc, 'empleados');
	rewrite(arc);
	reset(arc_txt);
	if(not EOF(arc_txt))then
		readln(arc_txt, e.cod, e.monto, e.nombre);
	while(not EOF(arc_txt))do
	begin
		empleados:= e;
		monto:= 0;
		while((not EOF(arc_txt)) and (e.cod = empleados.cod))do
			begin
				monto:= monto + e.monto;
				readln(arc_txt, e.cod, e.monto, e.nombre);
			end;
		if e.cod = empleados.cod then
			monto := monto + e.monto;
		empleados.monto:= monto;
		write(arc, empleados);
	end;
	if e.cod <> empleados.cod then
	begin
		empleados := e;
		empleados.monto := e.monto;
		write(arc, empleados);
	end;
	close(arc);
	close(arc_txt);
end;

procedure imprimirArc(var arc: archivo);
var
    e: empleado;
begin
    reset(arc);
    while(not EOF(arc)) do
    begin
		read(arc, e);
        writeln('Codigo = ', e.cod, ' Nombre = ', e.nombre, ' Monto Total = ', e.monto:0:2);
    end;
    close(arc);
end;

procedure imprimirTxt(var arc: text);
var
	e: empleado;
begin
	reset(arc);
	while(not EOF(arc))do
	begin
		readln(arc, e.cod, e.monto, e.nombre);
		writeln('Codigo = ', e.cod, ' Nombre = ', e.nombre, ' Monto Total = ', e.monto:0:2);
	end;
	close(arc);
end;

var
	arc_txt: text;
	arc: archivo;
begin
	assign(arc_txt, 'Empleados.txt');
	imprimirTxt(arc_txt);
	linea;
	crearArc(arc, arc_txt);
	imprimirArc(arc);
end.
