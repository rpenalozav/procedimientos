create view gps as
select id,
       activo,
       estado,
       case
           when fecha ~ '^\d{4}-\d{1,2}-\d{1,2}(.*)$' then to_timestamp(fecha, 'YYYY-MM-DD HH24:MI')
           when fecha ~ '^\d{1,2}/\d{1,2}/\d{4}(.*)$' then to_timestamp(fecha, 'DD/MM/YYYY HH24:MI')
           end fecha,
       ubicacion
from gps_activo;



select *
from
    select * from gps;
--create view prueba_mantenimiento as
select gps.activo,
       case
           when gps.fecha >= t.momento_inicial
               and gps.fecha <= t.momento_final then 'Mantenimiento'
           else gps.estado
           end estado,
       gps.fecha
from gps,
     disponibilidad_tiempo t
where gps.activo = t.activo_id and;


select *
from disponibilidad_mantenimiento
where momento_entrada > momento_salida;



select *
from disponibilidad_mantenimiento
where tipo_matenimiento = 'En evacuación';


select ((1 - ((sum(horas)) / ((EXTRACT(EPOCH FROM '2021-03-31 23:59:59.000000 -05:00'::timestamp -
                                                  '2021-03-01 00:00:00.000000 -05:00'::timestamp) / 3600) * 83))) *
        100),
       sum(horas)
from tiempomes_tipo_mantenimiento
where momento_inicial >= '2021-03-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-03-31 23:59:59.000000 -05:00'
union all
select ((1 - ((sum(horas)) / ((EXTRACT(EPOCH FROM '2021-03-31 23:59:59.000000 -05:00'::timestamp -
                                                  '2021-03-01 00:00:00.000000 -05:00'::timestamp) / 3600) * 84))) *
        100),
       sum(horas)
from tiempomes_tipo_mantenimiento
where momento_inicial >= '2021-02-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-02-28 23:59:59.000000 -05:00'
union all
select ((1 - ((sum(horas)) / ((EXTRACT(EPOCH FROM '2021-03-31 23:59:59.000000 -05:00'::timestamp -
                                                  '2021-03-01 00:00:00.000000 -05:00'::timestamp) / 3600) * 85))) *
        100),
       sum(horas)
from tiempomes_tipo_mantenimiento
where momento_inicial >= '2021-01-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-01-31 23:59:59.000000 -05:00'
union all
select ((1 - ((sum(horas)) / ((EXTRACT(EPOCH FROM '2021-03-31 23:59:59.000000 -05:00'::timestamp -
                                                  '2021-03-01 00:00:00.000000 -05:00'::timestamp) / 3600) * 85))) *
        100),
       sum(horas)
from tiempomes_tipo_mantenimiento
where momento_inicial >= '2020-12-01 00:00:00.000000 -05:00'
  and momento_final <= '2020-12-31 23:59:59.000000 -05:00';


-- 76
select count(distinct activo)                                              cantidad_vehiculos,
       'MARZO 2021',
       string_agg(DISTINCT disponibilidad_activo.tipo::text, ','::text) AS Tipo_vehiculo
from tiempomes_tipo_mantenimiento
         inner join disponibilidad_activo on tiempomes_tipo_mantenimiento.activo = disponibilidad_activo.id
where momento_inicial >= '2021-03-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-03-31 23:59:59.000000 -05:00'
union all
-- 85
select count(distinct activo)                                              cantidad_vehiculos,
       'FEBRERO 2021',
       string_agg(DISTINCT disponibilidad_activo.tipo::text, ','::text) AS Tipo_vehiculo
from tiempomes_tipo_mantenimiento
         inner join disponibilidad_activo on tiempomes_tipo_mantenimiento.activo = disponibilidad_activo.id
where momento_inicial >= '2021-02-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-02-28 23:59:59.000000 -05:00'
union all
select count(distinct activo)                                              cantidad_vehiculos,
       'ENERO 2021',
       string_agg(DISTINCT disponibilidad_activo.tipo::text, ','::text) AS Tipo_vehiculo
from tiempomes_tipo_mantenimiento
         inner join disponibilidad_activo on tiempomes_tipo_mantenimiento.activo = disponibilidad_activo.id
where momento_inicial >= '2021-01-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-01-31 23:59:59.000000 -05:00'
union all
select count(distinct activo)                                              cantidad_vehiculos,
       'DICIEMBRE 2020',
       string_agg(DISTINCT disponibilidad_activo.tipo::text, ','::text) AS Tipo_vehiculo
from tiempomes_tipo_mantenimiento
         inner join disponibilidad_activo on tiempomes_tipo_mantenimiento.activo = disponibilidad_activo.id
where momento_inicial >= '2020-12-01 00:00:00.000000 -05:00'
  and momento_final <= '2020-12-31 23:59:59.000000 -05:00'
union all
select count(distinct activo)                                              cantidad_vehiculos,
       'NOVIEMBRE 2020',
       string_agg(DISTINCT disponibilidad_activo.tipo::text, ','::text) AS Tipo_vehiculo
from tiempomes_tipo_mantenimiento
         inner join disponibilidad_activo on tiempomes_tipo_mantenimiento.activo = disponibilidad_activo.id
where momento_inicial >= '2020-11-01 00:00:00.000000 -05:00'
  and momento_final <= '2020-11-30 23:59:59.000000 -05:00';

--falta moto, hidrolavadora, minicargador

select *
from tiempomes_tipo_mantenimiento
order by momento_inicial desc;



select count(*)
from disponibilidad_activo
where tipo not in ('MOTO', 'CAMIONETA', 'CAMABAJA', 'ESTADIO', 'AUTOCOMPACTADOR')
  AND estado = 'Operativo';


select count(distinct activo_id)
from tiempo_mantenimiento
where momento_inicial >= '2021-03-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-03-31 23:59:59.000000 -05:00';


--741 tiempo_suplementario
--757 disponibilidad_tiempo


SELECT count(*)
FROM disponibilidad_mantenimiento m,
     disponibilidad_tiempo t
WHERE m.activo_id = t.activo_id
  AND m.momento_entrada >= t.momento_inicial
  AND m.momento_entrada <= t.momento_final
  and m.momento_entrada > '2021-03-01 00:00:00.000000 -05:00'
  AND (m.tipo_matenimiento::text <> ALL
       (ARRAY ['Pendiente'::character varying, 'Informado'::character varying, 'Logistico'::character varying, 'Siniestro'::character varying, 'En evacuación'::character varying]::text[]));

select count(*)
from disponibilidad_tiempo
union all
select count(*)
from tiempos_suplementarios;

select *
from tiempos_suplementarios
where momento_inicial >= '2021-03-01 00:00:00.000000 -05:00'
  and momento_final <= '2021-03-31 23:59:59.000000 -05:00';



select *
from disponibilidad_mantenimiento
where planeador = 'Fechafaltante';



SELECT *
from disponibilidad_mantenimiento
where momento_entrada >= '2021-03-01 00:00:00.000000 -05:00'
  and momento_salida <= '2021-03-31 23:59:59.000000 -05:00'
  and momento_real > '2021-03-31 23:59:59.000000 -05:00';

--'2021-03-01 00:00:00.000000 -05:00'

SELECT count(distinct t.activo_id)
FROM disponibilidad_mantenimiento m,
     disponibilidad_tiempo t
WHERE EXTRACT(MONTH FROM t.momento_inicial) = 3
  AND EXTRACT(YEAR FROM t.momento_inicial) = 2021
  AND (m.tipo_matenimiento::text <> ALL
       (ARRAY ['Pendiente'::character varying, 'Informado'::character varying, 'Logistico'::character varying, 'Siniestro'::character varying, 'En evacuación'::character varying]::text[]));


select *
from disponibilidad_tiempo
where EXTRACT(MONTH FROM momento_inicial) = 3
  AND EXTRACT(YEAR FROM momento_inicial) = 2021
  and momento_final is null;


SELECT t.activo,
       t.momento_inicial,
       t.momento_final,
       abs(date_part('epoch'::text, t.momento_final - t.momento_inicial)) / 3600::double precision AS horas,
       string_agg(DISTINCT m.tipo_matenimiento::text, ','::text)                                   AS tipo_mantenimiento,
       string_agg(DISTINCT m.ot::character varying::text, ','::text)                               AS ots
FROM disponibilidad_mantenimiento m,
     tiempo_dividido t
WHERE m.activo_id = t.activo
  AND m.momento_entrada >= t.momento_inicial
  AND m.momento_entrada <= t.momento_final
  AND (m.tipo_matenimiento::text <> ALL
       (ARRAY ['Pendiente'::character varying::text, 'Informado'::character varying::text, 'Logistico'::character varying::text, 'Siniestro'::character varying::text, 'En evacuación'::character varying::text]))
GROUP BY t.id
ORDER BY t.activo, t.momento_inicial;

select activo, count(activo)
from gps_activo
group by activo;


select *
from gps
where activo = 392
limit 200
    union all
select *
from gps
limit 250;

select distinct activo
from gps;



SELECT t.id,
       t.activo,
       t.momento_inicial,
       t.momento_final,
       abs(date_part('epoch'::text, t.momento_final - t.momento_inicial)) / 3600::double precision AS horas,
       string_agg(DISTINCT m.tipo_matenimiento::text, ','::text)                                   AS tipo_mantenimiento,
       string_agg(DISTINCT m.ot::character varying::text, ','::text)                               AS ots
FROM disponibilidad_mantenimiento m,
     tiempos_suplementarios t
    /*(select id,
            activo,
            momento_inicial,
            case
                when momento_final is null then now()
                when momento_final is not null then momento_final
                end as momento_final
     from tiempos_suplementarios) t */
WHERE m.activo_id = t.activo
  AND m.momento_entrada >= t.momento_inicial
  AND m.momento_entrada <= t.momento_final
  AND (m.tipo_matenimiento::text <> ALL
       (ARRAY ['Pendiente'::character varying::text, 'Informado'::character varying::text, 'Logistico'::character varying::text, 'Siniestro'::character varying::text, 'En evacuación'::character varying::text]))
  AND m.ot <> 999999999
GROUP BY t.id;
--ORDER BY t.activo, t.momento_inicial;


select id,
       activo     activo_id,
       momento_inicial,
       case
           when momento_final is null then now()
           when momento_final is not null then momento_final
           end as momento_final
from tiempos_suplementarios
order by momento_final desc;


create or replace view disponibilidad_motor_estructura_transmision_frenos as
select activo_id,
       sistema_id,
       momento_entrada,
       momento_salida,
       round((date_part('epoch'::text, mantenimiento_por_meses.momento_salida - momento_entrada) /
              3600::double precision)::numeric, 2) AS horas,
       tipo_matenimiento
from mantenimiento_por_meses
where sistema_id in (5, 1, 9, 4);


create table tiempo_motor_estructura_transmision_frenos
(
    id              serial not null primary key,
    activo          integer references disponibilidad_activo,
    momento_inicial timestamp with time zone,
    momento_final   timestamp with time zone,
    horas           numeric GENERATED ALWAYS AS (abs(extract(epoch from momento_final - momento_inicial)) / 3600) STORED
);


select count(*) from tiempo_motor_estructura_transmision_frenos;

create procedure depuracion_motor_estructura_transmision_frenos()
    language plpgsql
as
$$
declare
    conteo         int;
    inicial        timestamp;
    final_anterior timestamp;
    id             int;
    activo         int;
    --fue_nul        int;
    tiempo_reduntante cursor (acti int) for select activo_id, momento_entrada, momento_salida, tipo_matenimiento
                                            from disponibilidad_motor_estructura_transmision_frenos
                                            where activo_id = acti
--                                                   and tipo_matenimiento <> 'Pendiente'
                                            order by activo_id, momento_entrada;
    vehiculos cursor for select distinct activo_id
                         from disponibilidad_motor_estructura_transmision_frenos
                         order by activo_id;
begin
    execute 'delete from tiempo_motor_estructura_transmision_frenos';
    id := 0;
    for i in vehiculos
        loop
            conteo := 0;
            raise notice '%',i.activo_id;
            for j in tiempo_reduntante(i.activo_id)
                loop
                    conteo := conteo + 1;
                    if j.tipo_matenimiento <> 'Pendiente' then
                        if conteo = 1 then
                            inicial := j.momento_entrada;
                            final_anterior := j.momento_salida;
                        elsif conteo > 1 then
                            if j.momento_salida is not null then
                                if j.momento_entrada <= final_anterior then
                                    if j.momento_salida >= final_anterior then
                                        final_anterior := j.momento_salida;
                                    end if;
                                else
                                    id := id + 1;
                                    insert into tiempo_motor_estructura_transmision_frenos(id, activo, momento_inicial, momento_final)
                                    VALUES (id, j.activo_id, inicial, final_anterior);
                                    inicial := j.momento_entrada;
                                    final_anterior := j.momento_salida;
                                    activo := j.activo_id;
                                end if;
                            elsif j.momento_salida is null then
                                id := id + 1;
                                insert into tiempo_motor_estructura_transmision_frenos(id, activo, momento_inicial, momento_final)
                                VALUES (id, j.activo_id, inicial, now());
                                final_anterior := null;
                                exit;
                            end if;
                        end if;
                    end if;
                end loop;
            id := id + 1;
            if final_anterior is not null then
                raise notice '% | % | %',activo,inicial,final_anterior;
                insert into tiempo_motor_estructura_transmision_frenos(id, activo, momento_inicial, momento_final)
                VALUES (id, activo, inicial, final_anterior);
            end if;
        end loop;
    raise notice '%', id;
end;
$$;

call depuracion_motor_estructura_transmision_frenos();
