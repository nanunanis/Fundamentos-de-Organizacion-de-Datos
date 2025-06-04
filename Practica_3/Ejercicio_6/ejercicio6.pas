{
Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.

Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.

}

program ejercicio6;
const
	valor = 9999;
type
	prenda = record
		cod: integer;
		descripcion: string;
		color: string;
		tipo: string;
		stock: integer;
		precio: real;
	end;
	
	archivo = file of prenda;
	
	baja = file of integer;
	
procedure baja_logica(var a:archivo; var b:baja);
var
	p:prenda;
	cod:integer;
begin
	reset(a); reset(b);
	while(not EOF(b))do begin
		seek(a,0);
		read(a,p);
		read(b,cod);
		while((not EOF(a)) and (p.cod <> cod))do
			read(a,p);
		seek(a, filepos(a)-1);
		p.stock := -1;
		write(a, p);
	end;
	close(a); close(b);
end;

procedure reescribir_archivo(var a: archivo; var m:archivo; nombre: string);
var
	p:prenda;
begin
	assign(m, 'auxiliar');
	reset(a);
	rewrite(m);
	while(not EOF(a))do begin
		read(a, p);
		if(p.stock >= 0)then
			write(m, p);
	end;
	close(a); close(m);
	rename(a, 'Antiguo');
	rename(m, nombre);
end;
	
var
	a, m:archivo;
	b:baja;
	nombre: string;
begin
	nombre:= 'Maestro';
	assign(a, nombre);
	assign(b, 'Bajas');
	baja_logica(a,b);
	reescribir_archivo(a, m, nombre);
end.
