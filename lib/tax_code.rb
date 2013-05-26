require "tax_code/version"

class TaxCode
  class << self
    def taxes(path = '.')
      TaxCode.new(path).taxes    
    end

    def worst(path = '.', num = 10)
      TaxCode.new(path).worst(num)
    end
  
    def taxed_only(path = '.')
      TaxCode.new(path).taxed_only
    end
  end

  def initialize(path = '.')
    dir = path
    file = '.'
    unless File.directory? path
      dir = File.dirname path
      file = File.basename path
    end
    Dir.chdir(dir) do
      log = `git log --numstat -M #{file}`.encode('UTF-8', 'UTF-8', :invalid => :replace)
      raise 'Path has to be inside your git repository' if log == ""
      compute_history(log)
    end  
  end

  def taxes
    @hist.inject({}) do |res, (f, changes)|
      size, tax = changes[0][1], 0
      changes[1..-1].each do |c|
        tax += score(size, *c)
        size += c[1] - c[2]
      end
      size > 0 ? res.merge(f => [tax.to_i, 0].max) : res
    end
  end

  def taxed_only
    taxes.select{ |_, t| t > 0 }
  end

  def worst(num = 10)
    taxed_only..sort_by(&:last).last(num).reverse 
  end
  
private

  def score(s, age, a, d)
    hpr = 2 ** ( - age / 180.0)
    (s/40.0 + a * 2 - d ) * hpr 
  end

  def commits(log)
    log.split(/^Date:\s+(.*)$/)[1..-1].each_slice(2).map do |(d,all)| 
      age = (Date.today - Date.parse(d)).to_i 
      all.split(/\n/).grep(/^\d/).inject({}) do |h, s| 
        a, d, f = s.split(/\t/)
        h.merge f => [age, a.to_i, d.to_i]
      end
    end
  end

  def compute_history(log)
    @hist = Hash.new{|h,k| h[k] = []}
    commits(log).reverse.each do |cmt|
      cmt.each do |f, ar|
        fn = f
        if p = moved(f)
          fo, fn = p
          @hist[fn] = @hist[fo]
          @hist.delete(fo)
        end
        @hist[fn] << ar
      end
    end
  end

  def moved(f)
    if f =~ /^(.*){([^\s]*) => ([^\s}]*)}(.*)$/
      [$1 + $2 + $4, $1 + $3 + $4].map{|fn| fn.sub('//','/')}
    end
  end
end
