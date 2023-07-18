install.packages("readxl")
library(readxl)

rm(list=ls())
fichero<-"Datos Telefonia Separados Meses Comerciales.xlsx"
enero <- read_excel(fichero , sheet = "Facturación Enero 2020")
febrero <- read_excel(fichero , sheet = "Facturación Febrero 2020")
marzo <- read_excel(fichero , sheet = "Facturación Marzo 2020")
abril <- read_excel(fichero , sheet = "Facturación Abril 2020")
mayo <- read_excel(fichero , sheet = "Facturación Mayo 2020")
junio <- read_excel(fichero , sheet = "Facturación Junio 2020")

# Me aseguro que las columnas se llamen igual
nombres<-names(enero)
names(febrero)<-nombres
names(marzo)<-nombres
names(abril)<-nombres
names(mayo)<-nombres
names(junio)<-nombres

#uno en un solo fichero

semestre2020<-rbind(enero,febrero,marzo,abril,mayo,junio)


#elimino filas con caracteres vacios

semestre2020<-na.omit(semestre2020)

Sys.time()

#Calculo la edad
semestre2020$Edad<-as.numeric(floor((Sys.time()-semestre2020$`Fecha Nacimiento`)/365))


#Calculo la decada

for (i in 1:nrow(semestre2020)){
  semestre2020[i,"Década"]<-paste("Década", floor(semestre2020[i,"Edad"]/10)*10)
}

semestre2020$AñoFactura<-format(semestre2020$`Fecha factura`,"%Y")

semestre2020$MesFactura<-format(semestre2020$`Fecha factura`,"%m")


trimestreM200<-subset(trimestreM200,Country=="USA"|Country=="Panama")

jovenesNoBilbo<-subset(semestre2020,  Localidad!="Bilbao" & Edad<=60)

# Desar aquest dataframe nou, amb un fitxer excel a la mateixa carpeta, anomenat 
#“clients_menys_60.xlsx”

install.packages("openxlsx")
library(openxlsx)
# Save the dataframe as an Excel file
write.xlsx(jovenesNoBilbo, "clients_menys_60.xlsx")



