create or replace procedure ttf() AS
$$
declare
    fecha_ant         timestamp;
    contador          int;
    accum             double precision;
    insert_ttf        double precision;
    mantenimiento_ant varchar;
    restar            double precision;
    mi_cur cursor for select distinct activo_id
                      from disponibilidad_tiempo
                      order by activo_id;
    cur3 cursor (num int) for select *
                              from tiempo_mantenimiento
                              where activo_id = num
                              order by activo_id, momento_inicial;
BEGIN
    execute 'delete from mantenimiento_ttf';
    contador := 0;
    for i in mi_cur
        loop
            mantenimiento_ant := '';
            accum := 0;
            restar := 0;
            fecha_ant := NULL;
            raise notice '%',i.activo_id;
            for h in cur3(i.activo_id)
                loop
                    contador := contador + 1;
                    if h.tipo_mantenimiento = 'Preventivo' then
                        if mantenimiento_ant = 'Preventivo' then
                            restar := restar + h.horas;
                        else
                            mantenimiento_ant := h.tipo_mantenimiento;
                            restar := restar + h.horas;
                            --raise notice '% -> restar:%',h.tipo_mantenimiento, h.horas;
                        end if;
                        insert into mantenimiento_ttf(id, activo, momento_inicial, momento_final, tipo_mantenimiento, ot)
                        values (contador, h.activo_id, h.momento_inicial, h.momento_final, h.tipo_mantenimiento,
                                h.ots);
                    elsif accum = 0 then
                        mantenimiento_ant := h.tipo_mantenimiento;
                        insert into mantenimiento_ttf(id, activo, momento_inicial, momento_final, tipo_mantenimiento, ot)
                        values (contador, h.activo_id, h.momento_inicial, h.momento_final, h.tipo_mantenimiento, h.ots);
                        fecha_ant := h.momento_final;
                        restar := 0;
                    elseif accum > 0 then
                        mantenimiento_ant := h.tipo_mantenimiento;
                        insert_ttf := (abs(extract(epoch from h.momento_inicial - fecha_ant)) / 3600) - restar;
                        insert into mantenimiento_ttf(id, activo, momento_inicial, momento_final, tipo_mantenimiento,
                                                      ttf, ot)
                        values (contador, h.activo_id, h.momento_inicial, h.momento_final, h.tipo_mantenimiento,
                                insert_ttf,
                                h.ots);
                        fecha_ant := h.momento_final;
                        restar := 0;
                    end if;
                    accum := accum + 1;
                end loop;
        end loop;
    raise notice '%',contador;
END;
$$ LANGUAGE plpgsql;
