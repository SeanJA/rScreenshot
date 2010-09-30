class Screenshot

  #include java and the other classes we need for this
  include Java
  import java.awt.Desktop
  import java.awt.Robot
  import java.awt.GraphicsEnvironment
  import java.awt.GraphicsDevice
  import java.awt.Rectangle
  import javax.imageio.ImageIO

  def self.capture(file_name = 'screenshot.png')
    file_name = Time.now.to_i.to_s + file_name
    robot = Robot.new
    width = 0
    start_x = 0
    start_y = 0
    height = 0
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
    image = robot.create_screen_capture(rectangle)


    #windows desktop location
    desktop = ENV['USERPROFILE']+'/Desktop/'

    file  = java::io::File.new(desktop+file_name)
    ImageIO::write(image, "png", file)

    # Open the file in the users default application for the given file type
    desktop = Desktop.get_desktop
    desktop.open(file)
  end
end