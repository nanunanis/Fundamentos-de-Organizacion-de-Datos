{
   Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.
* 
Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos.

Cada registro incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos.

Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.

Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:

● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas.

● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado.

Notas:

● Los archivos deben procesarse en un único recorrido.

● No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar
ocurre con los exámenes finales.
      
}


program ejercicio7;
const
	valor = 9999;
type
	alumno = record
		cod_alumno: integer;
		nombre: string;
		cursadas: integer; // cantidad cusadas aprobadas
		finales: integer;  // cantidad finales aprobados
	end;
	
	maestro = file of alumno;
	
	cursadas = record
		cod_alumno: integer;
		cod_materia: integer;
		ano: integer;
		resultado: boolean;
	end;

	det_cursadas = file of cursadas;


	finales = record
		cod_alumno: integer;
		cod_materia: integer;
		fecha: string;
		nota: integer;
	end;
	
	det_finales = file of finales;

procedure leer(var m: maestro; var a: alumno);
begin
	if(not EOF(m))then
		read(m, a)
	else
		a.cod_alumno:= valor;
end;

procedure leerC(var d: det_cursadas; var c: cursadas);
begin
	if(not EOF(d))then
		read(d,c)
	else
		c.cod_alumno:= valor;
end;

procedure leerF(var d:det_finales; var f: finales);
begin
	if(not EOF(d))then
		read(d,f)
	else
		f.cod_alumno:= valor;
end;

procedure actualizarMaestro(var m: maestro; var dc: det_cursadas; var df: det_finales);
var
	c:cursadas; f:finales; a:alumno;
begin
	reset(m); reset(dc); reset(df);
	leer(m, a); leerC(dc, c); leerF(df, f);
	while(a.cod_alumno <> valor)do begin
		while((c.cod_alumno <> valor) and (a.cod_alumno = c.cod_alumno))do begin
			if(c.resultado)then
				a.cursadas := a.cursadas + 1;
			leerC(dc, c);
		end;
		while((f.cod_alumno <> valor) and (a.cod_alumno = f.cod_alumno))do begin
			if(f.nota >= 4)then
				a.finales := a.finales + 1;
			leerF(df, f);
		end;
		seek(m, filepos(m)-1);
		write(m, a);
		leer(m, a);
	end;
	close(m); close(dc); reset(df);
end;

var
	m: maestro;
	d1: det_cursadas;
	d2: det_finales;
begin
	assign(m, 'Maestro');
	assign(d1, 'Detalle1');
	assign(d2, 'Detalle2');
	actualizarMaestro(m,d1,d2);
end.

