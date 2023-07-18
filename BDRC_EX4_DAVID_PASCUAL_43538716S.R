rm(list = ls())


setwd("C:/CursR")
getwd()
install.packages("RODBC")
library(RODBC)
odbcDataSources()
dir()

canal<-odbcConnectAccess("Neptuno-2003.mdb")

canal
#sqlTables(canal)
#tablas de sistema
sqlTables(canal, tableType="SYSTEM TABLE")
#Tablas de usuario
sqlTables(canal, tableType="TABLE")
#Llistat de les taules
sqlTables(canal, tableType="TABLE")$TABLE_NAME
sqlColumns(canal,"Clientes")
sqlColumns(canal,"Clientes")$COLUMN_NAME

pedidos<-sqlFetch(canal,sqtable = "Pedidos")
detallePedidos<-sqlFetch(canal,sqtable = "Detalles de pedidos")
clientes<-sqlFetch(canal,sqtable = "Clientes")

#Carregar amb diferents dataframes les taules; Pedidos, Detalles de pedidos, 
#Clientes, mitjançant el comandament sqlFetch. 
# Carregar amb un Dataframe les taules Productos i Empleados, mitjançant una 
#sentencia SQL en el comandament sqlQuery. 

productos<-sqlQuery(canal, "SELECT * FROM Productos")
empleados<-sqlQuery(canal, "SELECT * FROM Empleados")

#Fer merge en un dataframe nou totalpedidos, de tots els dataframes carregats. 

totalPedidos<-merge(pedidos,detallePedidos, "IdPedido")
totalPedidos<-merge(totalPedidos,productos,"IdProducto")
totalPedidos<-merge(totalPedidos,empleados,"IdEmpleado")


# Veure la estructura del DataFrame nou totalpedidos

View(totalPedidos)


#En el dataframe totalpedidos, afegir una columna amb el any, un altre amb el 
#mes en lletres, un altre amb el dia de la setmana de la FechaPedido. 
# En el dataframe totalpedidos, afegir una columna nova amb el trimestre natural 
#que pertany a la FechaEntrega

totalPedidos$Año<-format(totalPedidos$FechaPedido,"%Y")
totalPedidos$Mes<-format(totalPedidos$FechaPedido,"%b")
totalPedidos$DíaSemana<-format(totalPedidos$FechaPedido,"%A")

trimestre<-c(1,1,1,2,2,2,3,3,3,4,4,4)

for (i in 1:nrow(totalPedidos)){
  #d1<-totalPedidos[i,"FechaEntrega"]
  d2<-as.numeric(format(totalPedidos[i,"FechaEntrega"],"%m"))
  d3<-trimestre[d2]
  #print(paste(d1,d2,d3))
  totalPedidos[i,"TrimestreEntrega"]<-d3
  
}

#Calcular en el dataframe totalpedidos, una columna nova anomenada total 
#mesos, amb els mesos transcorreguts de la FechaEnvio fins el dia “01/01/2020”

totalPedidos$totalMesos<-as.numeric(as.Date("2020-01-01")-as.Date(totalPedidos$FechaEnvío))/30

# En el dataframe totalpedidos, afegir una columna anomenada termini, que posi 
#“Fuera de plazo”, si el camp total mesos es mes gran de 100, si no posar “Dentro 
#de plazo”. 

#Tots estan fora de plaç , la data d'enviament més proprera el del 1998


for (i in 1:nrow(totalPedidos)){
  print(paste("meses",totalPedidos[i,"totalMesos"]))
  if(is.na(totalPedidos[i,"totalMesos"])){
    totalPedidos[i,"termini"]<-"NULL"
  } else if (totalPedidos[i,"totalMesos"]>100){
    totalPedidos[i,"termini"]<-"Fuera de plazo"
  } else {
    totalPedidos[i,"termini"]<-"Dentro de Plazo"
  }
}


#Crear un dataframe per veure la suma de importe (que serà igual a CanƟdad * 
# PrecioUnidad), agrupat per el cognom del comercial i el PaisDesƟnatario, 
#endreçat per aquest mateix ordre. 

importes<-totalPedidos[,c("Cantidad","PrecioUnidad.x")]
importes$importe<-importes$Cantidad*importes$PrecioUnidad.x
importes$apellidoComercial<-totalPedidos$Apellidos
importes$PaísDestinatario<-totalPedidos$PaísDestinatario

#si queremos borrar las columnas Cantida y PrecioUnidad.x

importes$Cantidad<-NULL
importes$PrecioUnidad.x<-NULL

#ahora podemos hacer el agregado

agregaComercialPaises<-aggregate(importes$importe, list(importes$apellidoComercial, importes$PaísDestinatario),sum)

agregaComercialPaises<-agregaComercialPaises[order(agregaComercialPaises$Group.1,agregaComercialPaises$Group.2),]

colnames(agregaComercialPaises)<-c("Comercial","País","Importe")


