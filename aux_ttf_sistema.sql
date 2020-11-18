do
$$
    declare
        activo      int;
        moment_ini1 timestamp;
        moment_fin1 timestamp;
        tipo_mante  varchar;
        sistema     int;
        ots         varchar;
        conteo      int;
        conteofinal int;
        cursor_activos cursor for select distinct activo_id
                                  from disponibilidad_mantenimiento;
        cursor_sistema cursor for select id
                                  from disponibilidad_sistema
                                  order by id;
        cursor_total cursor (h integer, l integer) for select activo_id,
                                                              momento_entrada                 momento_inicial,
                                                              coalesce(momento_salida, now()) momento_final,
                                                              tipo_matenimiento               tipo_mantenimiento,
                                                              sistema_id                      sistema,
                                                              ot
                                                       from disponibilidad_mantenimiento
                                                       where sistema_id = h
                                                         and activo_id = l
                                                       order by momento_entrada ;
    begin
        for h in cursor_activos
            loop
                activo := null;
                for i in cursor_sistema
                    loop
                        if activo is not null then
                            insert into aux_sistema_ttf(activo_id, momento_inicial, momento_final,
                                                        tipo_mantenimiento, sistema_id)
                            values (activo, moment_ini1, moment_fin1, tipo_mante, sistema);
--                             raise notice 'ffff%  %  %   %',activo, sistema, moment_ini1, moment_fin1;
                        end if;
                        activo := null;
                        moment_ini1 := null;
                        moment_fin1 := null;
                        tipo_mante := '';
                        sistema := null;
                        ots := '';
                        conteo := 0;
                        conteofinal := 0;
                        for f in cursor_total(i.id,h.activo_id)
                            loop
                                if conteo = 0 then--si es el primer registro por sistema
                                    activo := f.activo_id;
                                    moment_ini1 := f.momento_inicial;
                                    moment_fin1 := f.momento_final;
                                    tipo_mante := f.tipo_mantenimiento;
                                    sistema := f.sistema;
                                    ots := f.ot;
                                    conteo := conteo + 1;
                                    conteofinal := 0;
                                elseif conteo >= 1 then--si el tiempo
                                    if moment_fin1 >= f.momento_inicial then
                                        moment_fin1 := GREATEST(moment_fin1, f.momento_final);
                                        conteo := conteo + 1;
                                        conteofinal := conteofinal + 1;
                                    elseif conteo = 1 and moment_fin1 < f.momento_inicial then
                                        insert into aux_sistema_ttf(activo_id, momento_inicial, momento_final,
                                                                    tipo_mantenimiento, sistema_id)
                                        values (activo, moment_ini1, moment_fin1, tipo_mante, sistema);
                                        --raise notice '%  %  %  %   %',activo,ots, sistema, moment_ini1, moment_fin1;
                                        activo := f.activo_id;
                                        moment_ini1 := f.momento_inicial;
                                        moment_fin1 := f.momento_final;
                                        tipo_mante := f.tipo_mantenimiento;
                                        sistema := f.sistema;
                                        conteofinal := conteofinal + 1;
                                    elseif conteo > 1 then
                                        insert into aux_sistema_ttf(activo_id, momento_inicial, momento_final,
                                                                    tipo_mantenimiento, sistema_id)
                                        values (activo, moment_ini1, moment_fin1, tipo_mante, sistema);
--                                         raise notice '%  %  %  %   %',activo, ots, sistema, moment_ini1, moment_fin1;
                                        conteo := 0;
                                        conteofinal := conteofinal + 1;
                                    end if;
                                    if conteofinal = 0 and conteo = 1 then
                                        insert into aux_sistema_ttf(activo_id, momento_inicial, momento_final,
                                                                    tipo_mantenimiento, sistema_id)
                                        values (activo, moment_ini1, moment_fin1, tipo_mante, sistema);
--                                         raise notice '%  %  %  %   %',activo, ots, sistema, moment_ini1, moment_fin1;
                                    end if;
                                end if;
                            end loop;
                    end loop;
            end loop;
    end;
$$;
