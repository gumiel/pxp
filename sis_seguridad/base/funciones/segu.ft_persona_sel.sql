--------------- SQL ---------------

CREATE OR REPLACE FUNCTION segu.ft_persona_sel (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla varchar,
  par_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 FUNCION: 		segu.ft_persona_sel
 DESCRIPCION:   consultas de persona
 AUTOR: 		KPLIAN(jrr)
 FECHA:
 COMENTARIOS:
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCION:	actualizacion a nueva version xph
 AUTOR:		KPLIAN(jrr)
 FECHA:		08/01/11



 ISSUE            FECHA:         EMPRESA     AUTOR                 DESCRIPCION
  #40            31-07-2019      ETR          mzm                SEG_PERSONMIN_SEL:adicion de campos matricula, historia_clinica, fecha_nacimiento
  #55			 02.09.2019		 ETR		  MZM				 Adicion de campo abreviatura_titulo
***************************************************************************/

DECLARE


v_consulta    varchar;
v_parametros  record;
v_nombre_funcion   text;
v_mensaje_error    text;
v_resp varchar;


/*

'filtro'
'ordenacion'
'dir_ordenacion'
'puntero'
'cantidad'

*/

BEGIN

     v_parametros:=pxp.f_get_record(par_tabla);
     v_nombre_funcion:='segu.ft_persona_sel';


 /*******************************
 #TRANSACCION:  SEG_PERSON_SEL
 #DESCRIPCION:	Selecciona Personas
 #AUTOR:		KPLIAN(jrr)
 #FECHA:		08/01/11
***********************************/
     if(par_transaccion='SEG_PERSON_SEL')then

          --  Se arma la consulta de personas
          BEGIN

               v_consulta:='SELECT
                              p.id_persona,
                              p.ap_materno,
                              p.ap_paterno,
                              p.nombre,
                              p.nombre_completo1,
                              p.nombre_completo2,
                              p.ci,
                              p.correo,
                              p.celular1,
                              p.num_documento,
                              p.telefono1,
                              p.telefono2,
                              p.celular2,
                              per.fecha_nacimiento,
                              per.genero,
                              per.direccion,
                              per.tipo_documento,
                              per.expedicion

                          FROM segu.vpersona p
                          inner join segu.tpersona per on per.id_persona = p.id_persona
                          WHERE ';
               v_consulta:=v_consulta||v_parametros.filtro;
               v_consulta:=v_consulta || ' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
               --raise exception '%',v_consulta;
               return v_consulta;


         END;




/*******************************
 #TRANSACCION:  SEG_PERSON_CONT
 #DESCRIPCION:	Cuenta Personas
 #AUTOR:		KPLIAN(jrr)
 #FECHA:		08/01/11
***********************************/

     elsif(par_transaccion='SEG_PERSON_CONT')then

          --se arma la sonsulta que cuenta personas
          BEGIN

               v_consulta:='select count(p.id_persona)
               				FROM segu.vpersona p
                          	inner join segu.tpersona per on per.id_persona = p.id_persona
                          	WHERE ';
               v_consulta:=v_consulta||v_parametros.filtro;
               return v_consulta;
         END;


 /*******************************
 #TRANSACCION:  SEG_PERSONMIN_SEL
 #DESCRIPCION:	Selecciona Personas + fotografia
 #AUTOR:		KPLIAN(rac)
 #FECHA:		08/01/11
***********************************/
     elsif(par_transaccion='SEG_PERSONMIN_SEL')then

          --  Se arma la consulta de personas
          BEGIN

               v_consulta:='SELECT p.id_persona,
                             p.apellido_materno AS ap_materno,
                             p.apellido_paterno AS ap_paterno,
                             p.nombre,
                             (((COALESCE(p.nombre, '''' ::character varying) ::text || '' '' ::text) ||
                              COALESCE(p.apellido_paterno, '''' ::character varying) ::text) || '' ''
                               ::text) || COALESCE(p.apellido_materno, '''' ::character varying)
                                ::text AS nombre_completo1,
                             (((COALESCE(p.apellido_paterno, '''' ::character varying) ::text || '' ''
                              ::text) || COALESCE(p.apellido_materno, '''' ::character varying) ::text
                              ) || '' '' ::text) || COALESCE(p.nombre, '''' ::character varying) ::text
                               AS nombre_completo2,
                             p.ci,
                             p.correo,
                             p.celular1,
                             p.num_documento,
                             p.telefono1,
                             p.telefono2,
                             p.celular2,
                             p.direccion,  --#88
                             p.extension,
                             p.tipo_documento,
                             p.expedicion,
                             p.foto
                             --#40; MZM 31.07.2019
                              , p.matricula, p.historia_clinica, p.fecha_nacimiento, p.genero, p.grupo_sanguineo
                             --fin #40
                             --#55 - 02.09.2019
                             ,p.abreviatura_titulo
                             --#fin
                             --#59 09.09.2019
                             , p.profesion,
                             --#59 09.09.2019,
                            p.nombre_archivo_foto,
                            p.sobrenombre,
                            p.cualidad_1,
                            p.cualidad_2
                          FROM segu.tpersona p WHERE ';


               v_consulta:=v_consulta||v_parametros.filtro;
               v_consulta:=v_consulta || ' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
               --raise exception '%',v_consulta;
               return v_consulta;


         END;
/*******************************
 #TRANSACCION:  SEG_OPERFOT_SEL
 #DESCRIPCION:	Selecciona Personas + fotografia
 #AUTOR:		KPLIAN(rac)
 #FECHA:		23/04/13
***********************************/
     elsif(par_transaccion='SEG_OPERFOT_SEL')then

          --  Se arma la consulta de personas
          BEGIN

               v_consulta:='SELECT p.id_persona,
                             p.extension,
                             p.foto
                          FROM segu.tpersona p
                          inner join segu.tusuario u on u.id_persona = p.id_persona
                          WHERE u.id_usuario='||v_parametros.id_usuario;

                raise notice '%',v_consulta;

                return v_consulta;


         END;

/*******************************
 #TRANSACCION:  SEG_PERSONMIN_CONT
 #DESCRIPCION:	Cuenta Personas con foto
 #AUTOR:		KPLIAN(jrr)
 #FECHA:		08/01/11
***********************************/

     elsif(par_transaccion='SEG_PERSONMIN_CONT')then


          --se arma la sonsulta que cuenta personas
          BEGIN

               v_consulta:='select count(p.id_persona)
               from segu.tpersona p where ';
               v_consulta:=v_consulta||v_parametros.filtro;
               return v_consulta;
         END;

     else
         raise exception 'No existe la opcion';

     end if;

EXCEPTION

      WHEN OTHERS THEN
    	v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
    	v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
  		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;