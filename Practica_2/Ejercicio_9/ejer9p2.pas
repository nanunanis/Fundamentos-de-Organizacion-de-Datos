{
Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.
}

program ejercicio9;
const
	valor = 999;
type
	ventas = record
		cod: integer;
		nombre: string;
		ano: integer;
		mes: integer;
		dia: integer;
		monto: real;
	end;
	
	maestro = file of ventas;

procedure leer(var m: maestro; var v:ventas);
begin
	if(not EOF(m))then
		read(m, v)
	else
		v.cod:= valor;
end;

procedure informe(var m:maestro);
var
	v, aux:ventas;
	total_mes, total_ano, total_vendido:real;
begin
	reset(m);
	leer(m, v);
	total_vendido:= 0;
	while(v.cod <> valor)do begin
		aux:= v;
		total_ano:= 0;
		writeln('Nombre del cliente: '); read(v.nombre);
		while((v.cod <> valor) and (v.cod = aux.cod) and (v.ano = aux.ano))do begin
			total_mes:= 0;
			while((v.cod <> valor) and (v.cod = aux.cod) and (v.ano = aux.ano) and (v.mes = aux.mes))do begin
				total_mes:= total_mes + v.monto;
				leer(m,v)
			end;
			writeln('El total vendido del mes ', aux.mes,' es: ', total_mes);
			total_ano:= total_ano + total_mes;
		end;
		writeln('El total vendido en el año ' , aux.ano, ' es: ', total_ano);
		total_vendido:= total_vendido + total_ano;
	end;
	writeln('El monto total vendido de la empresa es: ', total_vendido);
	close(m);
end;

var		
	m: maestro;
begin
	assign(m, 'ventas');
	informe(m);
end.
