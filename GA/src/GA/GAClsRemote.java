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

import com.mathworks.toolbox.javabuilder.pooling.Poolable;
import java.util.List;
import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * The <code>GAClsRemote</code> class provides a Java RMI-compliant interface to the 
 * M-functions from the files:
 * <pre>
 *  /home/louis/Dropbox/CODE/Code_GA/GA_final/GA_GUI.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a <code>GAClsRemote</code> 
 * instance when it is no longer needed to ensure that native resources allocated by this 
 * class are properly freed, and the server-side proxy is unexported.  (Failure to call 
 * dispose may result in server-side threads not being properly shut down, which often 
 * appears as a hang.)  
 *
 * This interface is designed to be used together with 
 * <code>com.mathworks.toolbox.javabuilder.remoting.RemoteProxy</code> to automatically 
 * generate RMI server proxy objects for instances of GA.GACls.
 */
public interface GAClsRemote extends Poolable
{
    /**
     * Provides the standard interface for calling the <code>GA_GUI</code> M-function 
     * with 1 input argument.  
     *
     * Input arguments to standard interface methods may be passed as sub-classes of 
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of any 
     * supported Java type (i.e. scalars and multidimensional arrays of any numeric, 
     * boolean, or character type, or String). Arguments passed as Java types are 
     * converted to MATLAB arrays according to default conversion rules.
     *
     * All inputs to this method must implement either Serializable (pass-by-value) or 
     * Remote (pass-by-reference) as per the RMI specification.
     *
     * M-documentation as provided by the author of the M function:
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
     *
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the M function.
     *
     * @return Array of length nargout containing the function outputs. Outputs are 
     * returned as sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>. 
     * Each output array should be freed by calling its <code>dispose()</code> method.
     *
     * @throws java.jmi.RemoteException An error has occurred during the function call or 
     * in communication with the server.
     */
    public Object[] GA_GUI(int nargout, Object... rhs) throws RemoteException;
  
    /** Frees native resources associated with the remote server object */
    void dispose() throws RemoteException;
}
