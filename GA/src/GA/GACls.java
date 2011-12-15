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
import java.util.*;

/**
 * The <code>GACls</code> class provides a Java interface to the M-functions
 * from the files:
 * <pre>
 *  /home/louis/Dropbox/CODE/Code_GA/GA_final/GA_GUI.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a <code>GACls</code> instance 
 * when it is no longer needed to ensure that native resources allocated by this class 
 * are properly freed.
 * @version 0.0
 */
public class GACls extends MWComponentInstance<GACls>
{
    /**
     * Tracks all instances of this class to ensure their dispose method is
     * called on shutdown.
     */
    private static final Set<Disposable> sInstances = new HashSet<Disposable>();

    /**
     * Maintains information used in calling the <code>GA_GUI</code> M-function.
     */
    private static final MWFunctionSignature sGA_GUISignature =
        new MWFunctionSignature(/* max outputs = */ 1,
                                /* has varargout = */ true,
                                /* function name = */ "GA_GUI",
                                /* max inputs = */ 1,
                                /* has varargin = */ true);

    /**
     * Shared initialization implementation - private
     */
    private GACls (final MWMCR mcr) throws MWException
    {
        super(mcr);
        // add this to sInstances
        synchronized(GACls.class) {
            sInstances.add(this);
        }
    }

    /**
     * Constructs a new instance of the <code>GACls</code> class.
     */
    public GACls() throws MWException
    {
        this(GAMCRFactory.newInstance());
    }
    
    private static MWComponentOptions getPathToComponentOptions(String path)
    {
        MWComponentOptions options = new MWComponentOptions(new MWCtfExtractLocation(path),
                                                            new MWCtfDirectorySource(path));
        return options;
    }
    
    /**
     * @deprecated Please use the constructor {@link #GACls(MWComponentOptions componentOptions)}.
     * The <code>com.mathworks.toolbox.javabuilder.MWComponentOptions</code> class provides API to set the
     * path to the component.
     * @param pathToComponent Path to component directory.
     */
    public GACls(String pathToComponent) throws MWException
    {
        this(GAMCRFactory.newInstance(getPathToComponentOptions(pathToComponent)));
    }
    
    /**
     * Constructs a new instance of the <code>GACls</code> class. Use this constructor to 
     * specify the options required to instantiate this component.  The options will be 
     * specific to the instance of this component being created.
     * @param componentOptions Options specific to the component.
     */
    public GACls(MWComponentOptions componentOptions) throws MWException
    {
        this(GAMCRFactory.newInstance(componentOptions));
    }
    
    /** Frees native resources associated with this object */
    public void dispose()
    {
        try {
            super.dispose();
        } finally {
            synchronized(GACls.class) {
                sInstances.remove(this);
            }
        }
    }
  
    /**
     * Invokes the first m-function specified by MCC, with any arguments given on
     * the command line, and prints the result.
     */
    public static void main (String[] args)
    {
        try {
            MWMCR mcr = GAMCRFactory.newInstance();
            mcr.runMain( sGA_GUISignature, args);
            mcr.dispose();
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
    
    /**
     * Calls dispose method for each outstanding instance of this class.
     */
    public static void disposeAllInstances()
    {
        synchronized(GACls.class) {
            for (Disposable i : sInstances) i.dispose();
            sInstances.clear();
        }
    }

    /**
     * Provides the interface for calling the <code>GA_GUI</code> M-function 
     * where the first input, an instance of List, receives the output of the M-function and
     * the second input, also an instance of List, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * % GA_GUI M-file for GA_GUI.fig
     * %      GA_GUI, by itself, creates a new GA_GUI or raises the existing
     * %      singleton*.
     * %
     * %      H = GA_GUI returns the handle to a new GA_GUI or the handle to
     * %      the existing singleton*.
     * %
     * %      GA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
     * %      function named CALLBACK in GA_GUI.M with the given input arguments.
     * %
     * %      GA_GUI('Property','Value',...) creates a new GA_GUI or raises the
     * %      existing singleton*.  Starting from the left, property value pairs are
     * %      applied to the GUI before GA_GUI_OpeningFunction gets called.  An
     * %      unrecognized property name or invalid value makes property application
     * %      stop.  All inputs are passed to GA_GUI_OpeningFcn via varargin.
     * %
     * %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
     * %      instance to run (singleton)".
     * %
     * % See also: GUIDE, GUIDATA, GUIHANDLES
     * </pre>
     * </p>
     * @param lhs List in which to return outputs. Number of outputs (nargout) is
     * determined by allocated size of this List. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs List containing inputs. Number of inputs (nargin) is determined
     * by the allocated size of this List. Input arguments may be passed as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or
     * as arrays of any supported Java type. Arguments passed as Java types are
     * converted to MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void GA_GUI(List lhs, List rhs) throws MWException
    {
        fMCR.invoke(lhs, rhs, sGA_GUISignature);
    }

    /**
     * Provides the interface for calling the <code>GA_GUI</code> M-function 
     * where the first input, an Object array, receives the output of the M-function and
     * the second input, also an Object array, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * % GA_GUI M-file for GA_GUI.fig
     * %      GA_GUI, by itself, creates a new GA_GUI or raises the existing
     * %      singleton*.
     * %
     * %      H = GA_GUI returns the handle to a new GA_GUI or the handle to
     * %      the existing singleton*.
     * %
     * %      GA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
     * %      function named CALLBACK in GA_GUI.M with the given input arguments.
     * %
     * %      GA_GUI('Property','Value',...) creates a new GA_GUI or raises the
     * %      existing singleton*.  Starting from the left, property value pairs are
     * %      applied to the GUI before GA_GUI_OpeningFunction gets called.  An
     * %      unrecognized property name or invalid value makes property application
     * %      stop.  All inputs are passed to GA_GUI_OpeningFcn via varargin.
     * %
     * %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
     * %      instance to run (singleton)".
     * %
     * % See also: GUIDE, GUIDATA, GUIHANDLES
     * </pre>
     * </p>
     * @param lhs array in which to return outputs. Number of outputs (nargout)
     * is determined by allocated size of this array. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs array containing inputs. Number of inputs (nargin) is
     * determined by the allocated size of this array. Input arguments may be
     * passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void GA_GUI(Object[] lhs, Object[] rhs) throws MWException
    {
        fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs), sGA_GUISignature);
    }

    /**
     * Provides the standard interface for calling the <code>GA_GUI</code>
     * M-function with 1 input argument.
     * Input arguments may be passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     *
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * % GA_GUI M-file for GA_GUI.fig
     * %      GA_GUI, by itself, creates a new GA_GUI or raises the existing
     * %      singleton*.
     * %
     * %      H = GA_GUI returns the handle to a new GA_GUI or the handle to
     * %      the existing singleton*.
     * %
     * %      GA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
     * %      function named CALLBACK in GA_GUI.M with the given input arguments.
     * %
     * %      GA_GUI('Property','Value',...) creates a new GA_GUI or raises the
     * %      existing singleton*.  Starting from the left, property value pairs are
     * %      applied to the GUI before GA_GUI_OpeningFunction gets called.  An
     * %      unrecognized property name or invalid value makes property application
     * %      stop.  All inputs are passed to GA_GUI_OpeningFcn via varargin.
     * %
     * %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
     * %      instance to run (singleton)".
     * %
     * % See also: GUIDE, GUIDATA, GUIHANDLES
     * </pre>
     * </p>
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the M function.
     * @return Array of length nargout containing the function outputs. Outputs
     * are returned as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
     * should be freed by calling its <code>dispose()</code> method.
     * @throws MWException An error has occurred during the function call.
     */
    public Object[] GA_GUI(int nargout, Object... rhs) throws MWException
    {
        Object[] lhs = new Object[nargout];
        fMCR.invoke(Arrays.asList(lhs), 
                    MWMCR.getRhsCompat(rhs, sGA_GUISignature), 
                    sGA_GUISignature);
        return lhs;
    }
}
