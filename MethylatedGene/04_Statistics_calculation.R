#Merge the redefined epiallele matrix, TE(CDS), DEG dummy variable together.
df <- merge(B73_all,df_TE, by = "gene", all.x = T)
df <- merge(df, df_DEG, by = "gene", all.x = T)
