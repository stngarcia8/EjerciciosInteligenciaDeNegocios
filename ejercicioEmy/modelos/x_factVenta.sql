SELECT
    CONVERT(INT, CONVERT(DATETIME, vta.FEC_VENTA)) AS ID_FECHA,
    dbo.empleado.ID_EMPLEADO,
    dbo.empleado.ID_SUCURSAL,
    vta.ID_CLIENTE,
    con.ID_CONTRATO,
    dbo.documento.ID_DOCUMENTO,
    vta.MONTO_VENTA,
    CASE WHEN dbo.documento.ID_ESTADo = 1 THEN 1 ELSE 0 END AS DOC_PAGADO,
    CASE WHEN dbo.documento.ID_ESTADo = 2 THEN 1 ELSE 0 END AS DOC_VENCIDO,
    CASE WHEN dbo.documento.ID_ESTADo = 3 THEN 1 ELSE 0 END AS DOC_PENDIENTE,
    CASE WHEN dbo.documento.ID_TIPO = 1 THEN 1 ELSE 0 END AS ES_BOLETA,
    CASE WHEN dbo.documento.ID_TIPO = 2 THEN 1 ELSE 0 END AS ES_FACTURA,
    dbo.documento.MONTO_DOCUMENTO AS MONTO_PAGADO,
    CASE WHEN dbo.cliente.ID_TIPO=2 THEN 1 ELSE 0 END AS CLIENTE_COORPORATIVO,
    CASE 
    WHEN (SELECT
        count(id_cliente)
    FROM
        dbo.venta
    WHERE id_cliente=vta.id_cliente AND fec_venta<vta.fec_venta)=0 THEN 1
    ELSE 0 
    END AS CLIENTE_NUEVO ,
    (SELECT
        count(id_cliente)
    FROM
        dbo.venta
    WHERE id_cliente=vta.id_cliente AND fec_venta<vta.fec_venta) AS CANTIDAD_COMPRAS_ANTERIORES,
    (SELECT
        count(id_contrato)
    FROM
        dbo.detalle_contrato
    WHERE id_contrato=con.id_contrato ) 
    AS CANTIDAD_DISPOSITIVOS_CONTRATADOS
FROM
    dbo.venta vta
    INNER JOIN dbo.empleado ON vta.ID_EMPLEADO = dbo.empleado.ID_EMPLEADO
    INNER JOIN dbo.contrato con ON vta.ID_CONTRATO = con.ID_CONTRATO
    INNER JOIN dbo.detalle_contrato ON con.ID_CONTRATO = dbo.detalle_contrato.ID_CONTRATO
    INNER JOIN dbo.documento ON vta.ID_VENTA = dbo.documento.ID_VENTA
    INNER JOIN dbo.cliente ON vta.ID_CLIENTE = dbo.cliente.ID_CLIENTE
WHERE vta.id_cliente = 55
ORDER BY vta.fec_venta 