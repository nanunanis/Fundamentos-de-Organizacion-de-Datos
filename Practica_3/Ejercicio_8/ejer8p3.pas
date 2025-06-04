{
   Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento,
número deversión del kernel, cantidad de desarrolladores y descripción.

El nombre de las distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un
nombre de distribución y devuelve la posición dentro del archivo donde se
encuentra el registro correspondiente a la distribución dada (si existe) o
devuelve -1 en caso de que no exista.

b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro
que contiene los datos de una nueva distribución, y se encarga de agregar
la distribución al archivo reutilizando espacio disponible en caso de que
exista. (El control de unicidad lo debe realizar utilizando el módulo anterior).
En caso de que la distribución que se quiere agregar ya exista se debe
informar “ya existe la distribución”.

c. BajaDistribucion: módulo que recibe como parámetro el archivo y el
nombre de una distribución, y se encarga de dar de baja lógicamente la
distribución dada. Para marcar una distribución como borrada se debe
utilizar el campo cantidad de desarrolladores para mantener actualizada
la lista invertida. Para verificar que la distribución a borrar exista debe utilizar
el módulo BuscarDistribucion. En caso de no existir se debe informar
“Distribución no existente”.
    
}


program ejercicio8;
const
	valor = 'zzz';
type
	distribucion = record
		nombre: string;
		year: integer;
		kernel: real;
		desarrolladores: integer;
		descripcion: string;
	end;
	
	archivo = file of distribucion;

procedure leer(var a:archivo; var d:distribucion);
begin
	if(not EOF(a))then
		read(a,d)
	else
		d.nombre := valor;
end;
	
function BuscarDistribucion(var a:archivo; nombre:string):integer;
var
	d: distribucion;
	ok: boolean;
	pos: integer;
begin
	reset(a);
	ok:= false;
	while((not EOF(a)) and (not ok))do begin
		leer(a,d);
		if(d.nombre = nombre)then begin
			pos:= filepos(a)-1;
			ok:= true;
		end;
	end;
	if(not ok)then begin
		pos:= -1;
		writeln('El nombre de esa distribucion no existe');
	end;
	close(a);
	BuscarDistribucion:= pos;
end;

procedure AltaDistribucion(var a:archivo; d:distribucion);
var
	d2: distribucion;
begin
	if(BuscarDistribucion(a, d.nombre) <> -1)then begin
		reset(a);
		leer(a,d2); // leo la cabecera del archivo
		if(d2.desarrolladores = 0) then begin // si no hay mas lugares disponibles agrego la nueva distribucion al final del archivo
			seek(a, filesize(a));
			write(a, d);
		end
		else begin
			seek(a, d2.desarrolladores * -1); // voy a la posicion disponible
			leer(a, d2); // leo la nueva cabecera
			seek(a, filepos(a)-1); // vuelvo a la anterior posicion
			write(a, d); // escribo los datos nuevos
			seek(a,0); // vuelvo al cabecera original
			write(a,d2); // escribo la cabecera actual
		end;
		close(a);
		writeln('Se agrego correctamente la distribucion de linux');
	end
	else
		writeln('Ya existe la distribucion');
end;

procedure baja_logica(var a:archivo; nombre:string);
var
	cabecera: distribucion;
	pos: integer;
begin
	pos:= BuscarDistribucion(a, nombre);
	if(pos <> -1)then begin
		reset(a);
		leer(a,cabecera);
		seek(a, pos);
		write(a, cabecera);
		cabecera.desarrolladores:= (filepos(a)-1) * -1;
		seek(a,0);
		write(a,cabecera);
		close(a);
	end
	else
		writeln('Distribucion no existente');
end;

function opcion():integer;
var
	op: integer;
begin
	writeln('0: Terminar el programa');
	writeln('1: Buscar una distribucion de Linux');
	writeln('2: Agregar una distribucion de Linux');
	writeln('3: Eliminar una distribucion de Linux');
	write('Elija una opcion: '); readln(op); 
	opcion:=op;
end;

procedure leer(var d:distribucion);
begin
	write('Ingrese el nombre de la distribucion: '); readln(d.nombre);
	write('Ingrese el año de lanzamiento: '); readln(d.year);
	write('Ingrese el numero de version de kernel: '); readln(d.kernel);
    write('Ingrese la cantidad de desarrolladores: '); readln(d.desarrolladores);
    write('Ingrese la descripcion: '); readln(d.descripcion);
end;

procedure indice(var a: archivo);
var
	i: integer;
	d:distribucion;
	nombre: string;
begin
	i:= opcion();
	while(i <> 0)do begin
		case i of
			1:
			begin
				write('Escriba el nombre de la distribucion que desea buscar: '); readln(nombre);
				if(BuscarDistribucion(a, nombre) = -1) then
					writeln('No se encontro la distribucion ', nombre); 
			end;
			2: 
			begin
				leer(d);
				AltaDistribucion(a,d);
			end;
			3: 
			begin
				write('Escriba el nombre de la distribucion que desea eliminar: '); readln(nombre);
				baja_logica(a, nombre);
			end;
		else
			writeln('Opcion invalida');
		i:= opcion();
		end; // no se que hace este end
	end;
    writeln('Finaliza el programa');
end;

var
	a: archivo;
begin
	assign(a, 'DistribucionDeLinux');
	indice(a);
end.
