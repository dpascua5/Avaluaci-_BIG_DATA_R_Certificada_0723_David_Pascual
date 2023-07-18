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

