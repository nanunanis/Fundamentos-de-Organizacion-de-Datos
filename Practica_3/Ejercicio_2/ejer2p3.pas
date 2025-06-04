{
Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.

Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}

program ejercicio2;
type
	asistente = record
		nro: integer;
		nombre: string;
		email: string;
		telefono: integer;
		dni: integer;
	end; 
	
	archivo = file of asistente;

procedure linea(); begin writeln('-----------------------------'); end;
	
procedure informarcion(var a:asistente);
begin 
	write('Ingrese el numero del asistente: '); readln(a.nro);
	if(a.nro <> -1)then begin
		write('Ingrese el nombre del asistente: '); readln(a.nombre);
		// me da paja escribir todo el archivo, tampoco es necesario.
		//write('Ingrese el email del asistente: '); readln(a.email);
		//write('Ingrese el telefono del asistente: '); readln(a.telefono);
		//write('Ingrese el DNI del asistente: '); readln(a.dni);
	end;
end;	

procedure crearArchivo(var arc: archivo);
var
	a:asistente;
begin
	assign(arc, 'Asistentes');
	rewrite(arc);
	informarcion(a);
	while(a.nro <> -1)do begin
		write(arc, a);
		informarcion(a);
	end;
	close(arc);
end;

procedure imprimir(var a: archivo);
var
	asis: asistente;
begin
	reset(a);
	while(not EOF(a))do begin
		read(a, asis);
		// tecnicamente aca iria un if y que ignore los nombres que comienzan con @ pero como esto NO ES PYTHON, ni idea, Que imprima lo que se te cante el culo.
		writeln('Numero de asistente: ', asis.nro, ' Nombre: ', asis.nombre);//, ' Email: ', asis.email, ' Telefono: ', asis.telefono, ' DNI: ', asis.dni);
	end;
	close(a);
end;

procedure leer(var arc:archivo; var a:asistente);
begin
	if(not EOF(arc))then
		read(arc,a)
	else
		a.nro := -1;
end;

procedure baja_logica(var arc: archivo);
var
	a:asistente;
begin
	reset(arc);
	leer(arc, a);
	while(a.nro <> -1)do begin
		if(a.nro < 1000)then begin
			a.nombre:= '@' + a.nombre;
			seek(arc, filepos(arc)-1);
			write(arc, a);
		end;
		leer(arc,a);
	end;
	close(arc);
end;

var
	a: archivo;
begin
	crearArchivo(a);
	linea();
	imprimir(a);
	linea();
	baja_logica(a);
	imprimir(a);
end.
