create or replace procedure tiempo_meses() AS
$$
DECLARE
    dif_meses integer;
    dif_year  integer;
    mes_year  integer;
    cur_tabla cursor for select activo_id,
                                momento_inicial,
                                case
                                    when momento_final is null then now()
                                    when momento_final is not null then momento_final
                                    end momento_final
                         from disponibilidad_tiempo;
    cur_horas cursor for select *
                         from tiempo_dividido;
    contador  integer;
    meses     interval;
BEGIN
    contador := 0;
    execute 'delete from tiempo_dividido';
    execute 'set timezone = ''America/Bogota''';
    for i in cur_tabla
        loop
            dif_meses := extract(month from i.momento_final) - extract(month from i.momento_inicial);
            mes_year := (DATE_PART('year', i.momento_final::date) - DATE_PART('year', i.momento_inicial::date)) * 12 +
                        (DATE_PART('month', i.momento_final::date) - DATE_PART('month', i.momento_inicial::date));
            dif_year := extract(year from i.momento_final) - extract(year from i.momento_inicial);
            if dif_meses > 0 and dif_year = 0 then
                contador := contador + 1;
                for j in 0 .. dif_meses
                    loop
                        if j = 0 then
                            insert into tiempo_dividido(activo, momento_inicial, momento_final)
                            values (i.activo_id, i.momento_inicial,
                                    date_trunc('month', i.momento_inicial::date) + interval '1 month' -
                                    interval '1 day' +
                                    interval '23 hour, 59 minute, 59 second');
                        elsif j = dif_meses then
                            insert into tiempo_dividido(activo, momento_inicial, momento_final)
                            values (i.activo_id, date_trunc('month', i.momento_final), i.momento_final);
                        else
                            meses := j + 1 || ' month';
                            insert into tiempo_dividido(activo, momento_inicial, momento_final)
                            values (i.activo_id, date_trunc('month', i.momento_inicial) + meses - interval '1 month',
                                    date_trunc('month', i.momento_inicial::date) + meses -
                                    interval '1 day' +
                                    interval '23 hour, 59 minute, 59 second');
                        end if;
                    end loop;
            elsif dif_meses = 0 and dif_year = 0 then
                insert into tiempo_dividido(activo, momento_inicial, momento_final)
                values (i.activo_id, i.momento_inicial, i.momento_final);
            elsif dif_year > 0 then
                for j in 0 .. mes_year
                    loop
                        if j = 0 then
                            insert into tiempo_dividido(activo, momento_inicial, momento_final)
                            values (i.activo_id, i.momento_inicial,
                                    date_trunc('month', i.momento_inicial::date) + interval '1 month' -
                                    interval '1 day' +
                                    interval '23 hour, 59 minute, 59 second');
                        elsif j = mes_year then
                            insert into tiempo_dividido(activo, momento_inicial, momento_final)
                            values (i.activo_id, date_trunc('month', i.momento_final), i.momento_final);
                        else
                            meses := j + 1 || ' month';
                            insert into tiempo_dividido(activo, momento_inicial, momento_final)
                            values (i.activo_id, date_trunc('month', i.momento_inicial) + meses - interval '1 month',
                                    date_trunc('month', i.momento_inicial::date) + meses -
                                    interval '1 day' +
                                    interval '23 hour, 59 minute, 59 second');
                        end if;
                    end loop;
            end if;
        end loop;
END ;
$$ LANGUAGE plpgsql;
