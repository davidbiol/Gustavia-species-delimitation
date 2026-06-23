library(ecospat)
library(raster)
library(dismo)
library(ade4)
library(SDMTools)

sp1<-read.csv("fasciculata.csv", header=T, sep=",")
sp2<-read.csv("gentryi.csv", header=T, sep=",")
capas_sp1<- list.files("bios_sp1/",
            pattern = "*.asc$",full.names = TRUE)
clima_sp1<- stack(capas_sp1)

capas_sp2<- list.files("bios_sp3/",
            pattern = "*.asc$",full.names = TRUE)
clima_sp2<- stack(capas_sp2)

climALL <- mosaic(clima_sp1,clima_sp2, fun=mean)
names(climALL) <- names(clima_sp1)

clim_M_sp1 <- as.data.frame(rasterToPoints(clima_sp1))
clim_M_sp2 <- as.data.frame(rasterToPoints(clima_sp2))
clim_M_all <- as.data.frame(rasterToPoints(climALL))
head(clim_M_sp1)

clim_occ_sp1<- extract(clima_sp1, sp1[,c(2,3)])
clim_occ_sp2<- extract(clima_sp2, sp2[,c(2,3)])
head(clim_occ_sp1)
summary(clim_occ_sp1)

xy_sp1<-sp1[,2:3]
colnames(xy_sp1)[1]="x"
colnames(xy_sp1)[2]="y"

xy_sp2<-sp2[,2:3]
colnames(xy_sp2)[1]="x"
colnames(xy_sp2)[2]="y"

clim_p_sp1<-cbind(xy_sp1, clim_occ_sp1)
clim_p_sp2<-cbind(xy_sp2, clim_occ_sp2)


data<- rbind(clim_M_all[,3:17], clim_M_sp1[,3:17],clim_M_sp2[,3:17],clim_p_sp1[,3:17], clim_p_sp2[,3:17])

w<-c(rep(1,nrow(clim_M_all)) ,rep(0,nrow(clim_M_sp1)),rep(0,nrow(clim_M_sp2)),rep(0,nrow(clim_p_sp1)),rep(0,nrow(clim_p_sp2)))

pca.cal <-dudi.pca(data, row.w = w, center = T, scale = T, scannf = F, nf = 2)

head(pca.cal)

row.clim.all<-1:nrow(clim_M_all)

row.clim.sp1<-(1+nrow(clim_M_all)):(nrow(clim_M_all) + nrow(clim_M_sp1))

row.clim.sp2<-(1+nrow(clim_M_all)+nrow(clim_M_sp1)):(nrow(clim_M_all)+nrow(clim_M_sp1)+nrow(clim_M_sp2))

row.sp1<-(1+nrow(clim_M_all)+nrow(clim_M_sp1)+nrow(clim_M_sp2)):(nrow(clim_M_all)+nrow(clim_M_sp1)+nrow(clim_M_sp2)+nrow(clim_p_sp1))

row.sp2 <-(1+nrow(clim_M_all)+nrow(clim_M_sp1)+nrow(clim_M_sp2)+nrow(clim_p_sp1)) : (nrow(clim_M_all)+nrow(clim_M_sp1)+nrow(clim_M_sp2)+nrow(clim_p_sp1)+ nrow(clim_p_sp2))


scores.clim.all    <- pca.cal$li[row.clim.all,] 

scores.clim.sp1 <- pca.cal$li[row.clim.sp1,] 
scores.clim.sp2 <- pca.cal$li[row.clim.sp2,] 

scores.sp1 <- pca.cal$li[row.sp1,] 

scores.sp2 <- pca.cal$li[row.sp2,] 


ecospat.plot.contrib(contrib=pca.cal$co, eigen=pca.cal$eig)


z1<-ecospat.grid.clim.dyn (scores.clim.all, scores.clim.sp1, scores.sp1, R=100)
z2<-ecospat.grid.clim.dyn (scores.clim.all, scores.clim.sp2, scores.sp2, R=100)

D_overlap<-ecospat.niche.overlap (z1=z1, z2=z2, cor=TRUE)
D_overlap$D  
D_overlap$I


a.dyn<-ecospat.niche.equivalency.test(z1=z1 , z2=z2, rep=1000) 

ecospat.plot.overlap.test(a.dyn,"D","Equivalencia")


b1.dyn<-ecospat.niche.similarity.test(z1=z2 , z2=z1, overlap.alternative = "higher", rep=100, rand.type=2)#solo z2 se aleatoriza, z1 queda fijo
b2.dyn<-ecospat.niche.similarity.test(z2=z1 , z1=z2, overlap.alternative = "higher",rep=100, rand.type=2)


ecospat.plot.overlap.test(b1.dyn,"D","")
ecospat.plot.overlap.test(b2.dyn,"D","")
ecospat.plot.niche (z1, title="sp1", name.axis1="PCA1", name.axis2="PCA2", cor=F)
ecospat.plot.niche (z2, title="sp2", name.axis1="PCA1", name.axis2="PCA2", cor=F)
ecospat.plot.niche.dyn(z1, z2, quant=0, interest=2, name.axis1="PCA1", name.axis2="PCA2")



