{Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un
procedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.
Notas:
● Los archivos detalle no están ordenados por ningún criterio.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
o inclusive, en diferentes máquinas}

program ejer3p3;
uses SysUtils;
const
	valor = -1;
type
	logs = record
		cod:integer;
		fecha: string;
		tiempo: real;
	end;
	
	archivo = file of logs;
	
	vector = array[1..5] of archivo;
	
procedure leer(var a: archivo; var l:logs);
begin
	if(not EOF(a))then
		read(a, l)
	else
		l.cod:= valor;
end;

procedure nombrar(var v:vector);
var
	i: integer;
	nombre: string;
begin
	for i:=1 to 5 do
	begin
		nombre:= 'detalle' + IntToStr(i);
		assign(v[i], nombre);
	end;
end;

procedure crearMaestro(var m:archivo; v:vector);
var
	ld, lm:logs;
	ok: boolean;
	i: integer;
begin
	assign(m,'Maestro');
	rewrite(m);
	for i:=1 to 5 do
		reset(v[i]); 
		leer(v[i],ld);
		while(ld.cod <> valor)do begin
			seek(m, 0);
			leer(m, lm);
			ok:= false;
			while((lm.cod <> valor) and (not ok))do begin
				if((lm.cod = ld.cod) and (lm.fecha = ld.fecha))then begin
					ok:=true;
					seek(m, filepos(m)-1);
					lm.tiempo := lm.tiempo + ld.tiempo;
					write(m,lm);
				end;
				leer(m, lm)
			end;
			if(not ok)then
				write(m, lm);
			leer(v[i], ld);
		end;
		close(v[i]);
	close(m);
end;

var
	v:vector;
	m:archivo;
begin
	nombrar(v);
	crearMaestro(m,v);
end.
