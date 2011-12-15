/*
 * MATLAB Compiler: 4.16 (R2011b)
 * Date: Thu Dec 15 18:58:39 2011
 * Arguments: "-B" "macro_default" "-W" "java:GA,GACls" "-T" "link:lib" "-d" 
 * "/home/louis/Dropbox/CODE/Code_GA/GA_final/GA/src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" "class{GACls:/home/louis/Dropbox/CODE/Code_GA/GA_final/GA_GUI.m}" 
 */

package GA;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class GAMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "GA_68C775CE61D52CC31C8B15EE5F34A4C6";
    
    /** Component name */
    private static final String sComponentName = "GA";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(GAMCRFactory.class)
        );
    
    
    private GAMCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            GAMCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{7,16,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
