do
$$
    declare
        conteo         int;
        inicial        timestamp;
        final_anterior timestamp;
        id             int;
        activo         int;
        --fue_nul        int;
        tiempo_reduntante cursor (acti int) for select activo_id, momento_entrada, momento_salida, tipo_matenimiento
                                                from disponibilidad_mantenimiento
                                                where activo_id = acti
--                                                   and tipo_matenimiento <> 'Pendiente'
                                                order by activo_id, momento_entrada;
        vehiculos cursor for select distinct activo_id
                             from disponibilidad_mantenimiento
                             order by activo_id;
    begin
        execute 'delete from tiempos_suplementarios';
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
                                        insert into tiempos_suplementarios(id, activo, momento_inicial, momento_final)
                                        VALUES (id, j.activo_id, inicial, final_anterior);
                                        inicial := j.momento_entrada;
                                        final_anterior := j.momento_salida;
                                        activo := j.activo_id;
                                    end if;
                                elsif j.momento_salida is null then
                                    id := id + 1;
                                    insert into tiempos_suplementarios(id, activo, momento_inicial, momento_final)
                                    VALUES (id, j.activo_id, inicial, null);
                                    final_anterior := null;
                                    exit;
                                end if;
                            end if;
                        end if;
                    end loop;
                id := id + 1;
                if final_anterior is not null then
                    raise notice '% | % | %',activo,inicial,final_anterior;
                    insert into tiempos_suplementarios(id, activo, momento_inicial, momento_final)
                    VALUES (id, activo, inicial, final_anterior);
                end if;
            end loop;
        raise notice '%', id;
    end;
$$;
