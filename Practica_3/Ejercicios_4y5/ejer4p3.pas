{
4.  Dada la siguiente estructura:
 
type
	reg_flor = record
		nombre: String[45];
		codigo: integer;
	end;
	tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:

Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente

	procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
   
5.  Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:

Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente

	procedure eliminarFlor (var a: tArchFlores; flor:reg_flor); 
}


program ejercicio4y5;
const
	valor = -9999;
type
	reg_flor = record
		nombre: string[45];
		codigo: integer;
	end;
	
	archivoF = file of reg_flor;

procedure leerFlor(var f: reg_flor);
begin
	write('Ingrese el codigo de una flor: '); readln(f.codigo);
	if(f.codigo <> -1)then begin
		write('Ingrese el nombre de la flor: '); readln(f.nombre);
	end;
end;

procedure crearArc(var a: archivoF);
var
	f: reg_flor;
begin
	assign(a, 'Flores');
	rewrite(a);
	f.nombre:= 'cabecera';
	f.codigo:= 0;
	write(a,f);
	leerFlor(f);
	while(f.codigo <> -1)do begin
		write(a,f);
		leerFlor(f);
	end;
	close(a);
end;

procedure leer(var a: archivoF; var f: reg_flor);
begin
	if(not EOF(a))then
		read(a,f)
	else
		f.codigo:= valor;
end;

procedure agregarFlor(var a: archivoF; nombre: string; codigo:integer);
var
	f, f2: reg_flor;
begin
	reset(a);
	f2.codigo:= codigo;
	f2.nombre:= nombre;
	leer(a,f);
	if(f.codigo = 0)then begin
		seek(a, filesize(a));
		write(a,f2);
	end
	else begin
		seek(a, f.codigo * -1);
		read(a, f);
		seek(a, filepos(a)-1);
		write(a,f2);
		seek(a,0);
		write(a,f);
	end;
	close(a);
end;

procedure imprimir(var a:archivoF);
var
	f:reg_flor;
begin
	reset(a);
	leer(a, f);
	while(f.codigo <> valor)do begin
		leer(a,f);
		if(f.codigo > 0)then
			writeln('Flor = ', f.nombre, ' Codigo = ', f.codigo);
	end;
	close(a);
end;

procedure eliminar(var a:archivoF; cod: integer);
var
	f, cabecera: reg_flor;
	ok: boolean;
begin
	reset(a);
	leer(a,cabecera);
	ok:= false;
	leer(a,f);
	while((f.codigo <> valor) and (not ok))do begin
		if(f.codigo = cod)then begin
			ok:= true;
			seek(a, filepos(a)-1); // vuelvo una posicion atras en el archivo
			write(a, cabecera); // escribo la cabecera en su nueva posicion 
			cabecera.codigo:= (filepos(a)-1)*-1; // guardo una nueva posicion de cabecera 
			seek(a,0); // vuelvo a la posicion inicial
			write(a, cabecera); // escribo la cabecera negativa en la posicion inicial
		end;
		leer(a,f);
	end;
	close(a);
end;

procedure linea(); begin writeln('---------------------------'); end;

var
	a:archivoF;
begin	
	crearArc(a);
	linea;
	imprimir(a);
	linea;
	agregarFlor(a, 'amapola', 16);
	imprimir(a);
	linea();
	eliminar(a, 15);
	imprimir(a);
end.
