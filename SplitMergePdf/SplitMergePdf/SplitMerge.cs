using System;
using System.Collections.Generic;
using iTextSharp.text.pdf;
using iTextSharp.text;
using iTextSharp.text.exceptions;
using System.IO;


namespace SplitMergePdf
{
    public class SplitMerge
    {
        public bool MergeFiles(string[] fileNames, string targetPdf)
        {
            bool merged = true;
            using (FileStream stream = new FileStream(targetPdf, FileMode.Create))
            {
                Document document = new Document();
                PdfCopy pdf = new PdfCopy(document, stream);
                PdfReader reader = null;
                PdfReader.unethicalreading = true;
                try
                {
                    document.Open();
                    int numDoc = 0;
                    foreach (string file in fileNames)
                    {

                        numDoc++;
                        bool isPasswordProtected = IsPasswordProtected(file);

                        if (isPasswordProtected)
                        {
                            continue;
                        }
                        else
                        {
                            reader = new PdfReader(file);
                        }

                        //RemoveSign(reader, file, numDoc);
                        RenameFields(reader, numDoc);
                        pdf.AddDocument(reader);
                        reader.Close();
                    }
                }
                catch (Exception)
                {
                    merged = false;
                    if (reader != null)
                    {
                        reader.Close();
                    }
                }
                finally
                {
                    if (document != null)
                    {
                        document.Close();
                    }
                }
            }
            return merged;
        }

        public int SplitFiles(string inputPath, string outputPath)
        {
            Document document = new Document();
            PdfReader reader = null;
            PdfReader.unethicalreading = true;
            int numberOfPages = 0;
            try
            {
                FileInfo file = new FileInfo(inputPath);
                string name = file.Name.Substring(0, file.Name.LastIndexOf("."));


                reader = new PdfReader(inputPath);
                numberOfPages = reader.NumberOfPages;

                for (int pagenumber = 1; pagenumber <= numberOfPages; pagenumber++)
                {
                    string filename = name + pagenumber.ToString() + ".pdf";

                    document = new Document();
                    PdfCopy copy = new PdfCopy(document, new FileStream(outputPath + "\\" + filename, FileMode.Create));

                    document.Open();

                    copy.AddPage(copy.GetImportedPage(reader, pagenumber));

                    document.Close();
                }

                reader.Close();
                reader.Dispose();
                return numberOfPages;
            }
            catch (Exception)
            {
                if (reader != null)
                {
                    reader.Close();
                }
                return numberOfPages;
            }
            finally
            {
                if (document != null)
                {
                    document.Close();

                }
            }


        }

        internal void RemoveSign(PdfReader reader, string file, int numDoc)
        {

            AcroFields fields = reader.AcroFields;
            List<String> names = fields.GetSignatureNames();

            foreach (String name in names)
            {
                IList<AcroFields.FieldPosition> fps = fields.GetFieldPositions(name);
                if (fps != null && fps.Count > 0)
                {
                    fields.RemoveField(name);
                }
            }
        }

        internal bool IsPasswordProtected(string inputFile)
        {
            try
            {
                PdfReader.unethicalreading = true;
                PdfReader reader = new PdfReader(inputFile);
                reader.Close();
                return false;
            }
            catch (BadPasswordException)
            {
                return true;
            }
        }

        internal void RenameFields(PdfReader reader, int numDoc)
        {
            ICollection<string> keys = reader.AcroFields.Fields.Keys;
            foreach (var key in keys)
            {
                reader.AcroFields.RenameField(key, String.Format("{0}{1}", key, numDoc));

            }


        }

    }
}
