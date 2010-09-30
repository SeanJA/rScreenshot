require 'rbconfig'

class Screenshot

  #include java and the java classes we need for this
  include Java
  import java.awt.Desktop
  import java.awt.Robot
  import java.awt.GraphicsEnvironment
  import java.awt.GraphicsDevice
  import java.awt.Rectangle
  import javax.imageio.ImageIO

  def self.capture(file_name = 'screenshot.png')
    #default values
    width,height,start_x,start_y = 0,0,0,0
    #timestamp the filename so that it doesn't overwrite the previous screenshot
    file_name = Time.now.to_i.to_s + '_' + file_name
    robot = Robot.new
    
    g_env = GraphicsEnvironment.get_local_graphics_environment
    g_env.get_screen_devices.each{ |d|
      configuration = d.get_default_configuration
      dim = configuration.get_bounds

      #always add up the widths of the monitors as a positive number
      width += dim.get_width.abs

      #use the tallest monitor as the height
      if(height < dim.get_height)
        height = dim.get_height
      end
    }
    rectangle = Rectangle.new(start_x, start_y, width, height)
    @image = robot.create_screen_capture(rectangle)

    save_image file_name
  end

  private

  def self.get_home_dir
    os = Config::CONFIG['host_os']
    #windows
    if os % 'mswin'
      home = ENV['USERPROFILE'] + '/Desktop/'
    #this should cover unix like oses
    else
      home = '~/Desktop/'
    end
  end

  def self.save_image file_name
    desktop = get_home_dir
    #save the image
    file  = java::io::File.new(desktop+file_name)
    ImageIO::write(@image, "png", file)

    # Open the image in the users default application
    desktop = Desktop.get_desktop
    desktop.open(file)
  end

end