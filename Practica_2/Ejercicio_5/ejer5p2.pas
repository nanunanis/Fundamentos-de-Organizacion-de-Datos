{
	Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log. 
}

program ejercicio5;
uses
    SysUtils;
const
	valor = 9999;
type
	datos = record
		cod: integer;
		fecha: string;
		tiempo: real;
	end;
	
	archivo = file of datos;
	
	archivos = array[1..3] of archivo;
	registros = array[1..3] of datos;
	
procedure linea(); begin writeln('--------------------------'); end;

procedure leer(var d: archivo; var sesion: datos);
begin
	if(not EOF(d))then
		read(d,sesion)
	else
		sesion.cod:= valor;
end;

procedure imprimir(var a:archivo);
var d:datos;
begin
	reset(a);
	while(not EOF(a))do
	begin
		read(a,d);
		writeln('Codigo=', d.cod, ' Fecha=', d.fecha, ' Tiempo=', d.tiempo:0:2);
	end;
	close(a);
end;

procedure arc_detalle(var d:archivos);
var
	i:integer;
	nombre:string;
begin
	for i:=1 to 3 do
	begin
		nombre:= 'Detalle' + IntToStr(i);
		assign(d[i], nombre);
		imprimir(d[i]);
		linea;
	end;
end;

procedure minimo(var vd: archivos; var vr: registros; var min:datos);
var
	i, pos:integer;
begin
	pos:= 1;
	min.cod:= valor;
	min.fecha:= 'zzz';
	for i:=1 to 3 do begin
		if(vr[i].cod < min.cod) or ((vr[i].cod = min.cod)  and (vr[i].fecha < min.fecha))then begin
			min:= vr[i];
			pos:= i;
		end;
	end;
	if(min.cod <> valor)then
		leer(vd[pos], vr[pos]);
end;

procedure crear_maestro(var m:archivo; var vd:archivos);
var
	vr: registros;
	min, aux: datos;
	i:integer;
begin
	rewrite(m);
	for i:=1 to 3 do
	begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.cod <> valor)do begin
		aux.cod:= min.cod;
		while((min.cod <> valor) and (aux.cod = min.cod))do begin
			aux.tiempo:= 0;
			aux.fecha:= min.fecha;
			while(min.cod <> valor) and (min.cod = aux.cod) and (min.fecha = aux.fecha)do begin
				aux.tiempo:= aux.tiempo + min.tiempo;
				minimo(vd,vr,min);
			end;
		end;
		write(m, aux);
	end;
	close(m);
	for i:=1 to 3 do
	begin
		close(vd[i]);
	end;
end;
	
var
	d: archivos;
	m: archivo;
begin
	arc_detalle(d);
	assign(m, 'Maestro');
	crear_maestro(m, d);
	linea;
	imprimir(m);
end.
