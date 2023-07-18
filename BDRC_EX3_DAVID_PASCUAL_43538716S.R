rm(list = ls())
#Ejercicio 2

#dos maneras alternativas de leer con librerias diferentes
#read_excel("clients_menys_60.xlsx")

factures<-read_xlsx("clients_menys_60.xlsx")
Franja_Edats<-read_xlsx("Datos Telefonia Separados Meses Comerciales.xlsx", sheet="Franja_Edades")

#pedidostotal<-merge(x=pedidos,y=detallepedidos,by=c("IdPedido"))



#Aqui el fallo esta en como contiene la informacion el campo Decada, en uno el numero, y en el otro un texto largo

for (i in 1:nrow(Franja_Edats)){
  Franja_Edats[i,"Decada"]<-paste("Década", Franja_Edats[i,"Decada"])
}

facturesFE<-merge(x=factures, y=Franja_Edats, by=c("Decada"))

#Al dataframe facturesFE, esborrar la columna Descripción.
#veo que es la columna 15


facturesFE<-facturesFE[,-15]


#Carregar en un DataFrame nou localidad el conjunto de datos del full Localidad 
#del fitxer “Datos Telefonia Separados Meses Comerciales.xlsx”.


localidad<-read_xlsx("Datos Telefonia Separados Meses Comerciales.xlsx", sheet="Localidad")

#Preparar les dades, per poder combinar amb el dataframe facturesFE, aïllant el 
#nom de la localitat de la primera columna, conservar la columna original. 

#Eliminare numero, la almohadilla y el espacio inicial
#pruebo con una expresion regular
#tambien podria identificar la posicion usar substring


localidad$Localidad<-sub('[0-9]*# ','', localidad$Localidad)

facturesFEL<-merge(x=facturesFE, y=localidad, by=c("Localidad"))

#Combinar els dataframes facturesFE amb localidad, en un de nou facturesFEL, 
#en aquest dataframe nou esborrar totes les columnes del dataframe localidad, 
#menys la columna Zona

#Localidad, Población, Satisfacción

facturesFEL$Localidad<-NULL
facturesFEL$Población<-NULL
facturesFEL$Satisfacción.y<-NULL

# Carregar les dades de la descripció de saƟsfacció del client, del fitxer “Datos 
# Telefonia Separados Meses Comerciales.xlsx”, en un dataframe nou anomenat
# SaƟsfacción_Cliente

Satisfacción_Cliente<-read_xlsx("Datos Telefonia Separados Meses Comerciales.xlsx", sheet="Satisfacción Cliente")

# Combinar els dataframes facturesFEL i SaƟsfacción_Cliente en un de nou 
#anomenat facturesFELS.

#Cambio el nombre y borro la antigua columna
facturesFEL$Satisfacción<-facturesFEL$Satisfacción.x
facturesFEL$Satisfacción.x<-NULL
#Llamo de la misma manera la collumna

Satisfacción_Cliente$`Satisfacción`<-Satisfacción_Cliente$`Satisfacción Cliente`
Satisfacción_Cliente$`Satisfacción Cliente`<-NULL


facturesFELS<-merge(x=facturesFEL, y=Satisfacción_Cliente)

#ParƟnt de facturesFELS, mostrar en un text el numero de factures de la Localidad 
#Andalucía. “El numero de factures a Andalucía es de X factures” 

#En ejercicios anteriores hemos borrado el campo localidad donde aparecia la palabra Andalucia
#en facturasfe si que existe el campo

contador=0
for(i in 1:nrow(facturesFE))
{
  if(facturesFE[i,"Localidad"]=="Andalucía"){
    contador<-contador+1
  }
}
print(paste("El numero de factures a Andalucía es de",contador,"factures"))


#ParƟnt de facturesFELS, calcular la suma de importe Factura de la Franja Classic 
#o de la Franja Middle, mostrar en un text “El total de facturació de la franja Classic 
#o Middle es de X euros”. 

classicMiddle<-subset(facturesFELS, Franja=="Franja Classic" | Franja=="Franja Middle")

importe=0
for(i in 1:nrow(classicMiddle))
{
  importe<-importe+classicMiddle[i,"Importe factura"]
}
print(paste("El total de facturació de la franja Classic o Middle es de",importe,"euros"))


#ParƟnt de facturesFELS, el promig de importe Factura de les dones de +30 anys 
#de la Zona Centro, mostrar en un text “El promig de facturació de les dones de 
#+30 de la Zona Centro es de X euros”, amb el valor de x redondeixat a dos 
#decimals. 

mujeres30centro<-subset(facturesFELS, Zona=="Centro" & Genero=="Mujer")
round(mean(mujeres30centro$`Importe factura`),2)
print(paste("El promig de facturació de les dones de +30 de la Zona Centro es de",round(mean(mujeres30centro$`Importe factura`),2),"euros"))

write.xlsx(facturesFELS , "factures_FLS.xlsx")

#ejercicio 3

setwd("C:/CursR")
getwd()

#: Importar les dades del fitxer “factures_FELS.xlsx” i carregar-les en un 
#dataframe anomenat factures, carregar en un altre dataframe, anomenat comercials
#que correspon al full “Comerciales” del fitxer “Datos Telefonia Separados Meses 
#Comerciales.xlsx” (Carpeta dades del github). 


dir()

library(readxl)

factures<-read_xlsx("factures_FLS.xlsx")
comercials<-read_xlsx("Datos Telefonia Separados Meses Comerciales.xlsx",sheet="Comerciales")

#Combinar en un data.frame nou, anomenat facturesCOM els dataframe 
#comercials i el data.frame factures

facturesCOM<-merge(x=factures,y=comercials,by=c("IdComercial"))

#Veure les dades de facturesCOM en una pestanya del quadrant Q1.

View(facturesCOM)
# Al dataframe facturesCOM, esborrar la columna Descripción.
#No se si borrar descripcion.x o Descripcion.y

facturesCOM$Descripción.x<-NULL
facturesCOM$Descripción.y<-NULL

#Mitjançant un bucle posar els mesos en lletres segons el numero de mes, en el 
#dataframe facturesCOM

#Mi no entender??? pondre el mes de la facturacion

meses<-c("Enero","Febrero","Marzo","Abril","Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre")

facturesCOM$mesLetras<-meses[as.numeric(facturesCOM$MesFactura)]


# En facturesCOM, en la columna Servicios, canviar el valor Otros per Fibra Plus 
#500


for(i in 1:nrow(facturesCOM)){
  if(facturesCOM[i,"Servicios"]=="Otros"){
    facturesCOM[i,"Servicios"]<-"Fibra Plus 500"
  }
}

#En facturesCOM, afegir una columna amb el nom de la companyia "Xiaomi Telecom"

facturesCOM$'Nombre Compañia'<-"Xiaomi Telecom"


#Mitjançant un bucle for, esborrar els registres del dataframe facturesCOM, si el 
#importe factura es menor de 20 i si el Comercial es "Oscar Mateo".

#Esto que propones tiene mas peligro que el caballo del malo.
#Si tienes un bucle de tamaño fijo, cuando borrar un elemento te pueden pasar dos cosAS
#Qque haya elementos que te saltes justo despues de borrar un elemento o que accedas a
#indices fueras del vector actualizado

facturesCOM$`Nombre Comercial`<-facturesCOM$Nombre.y
facturesCOM<-facturesCOM[!(facturesCOM$`Nombre Comercial`=="Oscar Mateo" & facturesCOM$`Importe factura`<20),]

#Veure en un text, la suma de importe factura dels clients que tenen contractat el 
#servei Fibra Plus 500 i que la seva edat esta compresa entre 25-40 anys.

suma<-0
for(i in 1:nrow(facturesCOM)){
  if(facturesCOM[i,"Servicios"]=="Fibra Plus 500" & facturesCOM[i,"Edad"]>=25 & facturesCOM[i,"Edad"]<=40){
    #print(facturesCOM[i,c("Servicios","Edad","Importe factura")])
    suma<-suma+facturesCOM[i,"Importe factura"]
  }
}

print(paste("la suma de importe factura dels clients que tenen contractat el servei Fibra Plus 500 i que la seva edat esta compresa entre 25-40 anys es de",suma,"euros."))

#Veure en un dataframe nou agrupatMC el promig de importe factura de 
#facturesCOM, agrupat per Mes, Mes Letras i nom del Comercial. 

#Agrupar dades de un dataframe, PaisDestinatario, farem servir
#aggregate, primer el nom del camp que volem resumir, segon una llista
#amb els camps que volem agrupar, el tipus, sum, mean, max, min


#agrupadopais<-aggregate(pedidostotal$Cantidad,
#                        list(pedidostotal$PaísDestinatario), mean)


agrupatMC<-aggregate(facturesCOM$`Importe factura`,list(facturesCOM$MesFactura,facturesCOM$mesLetras, facturesCOM$`Nombre Comercial`), mean)

#aqui reodeno par ver un poco más limpios los datos
agrupatMC[order(agrupatMC$Group.3,agrupatMC$Group.1),]

#Desar el dataframe agrupatMC amb un fitxer csv a la mateixa carpeta, anomenat 
#agrupat_mes.csv

write.csv(agrupatMC, "agrupat_mes.csv")

