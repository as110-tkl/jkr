
class Jkr
  class Analysis
    def self.analyze(env, resultset_num)
      if resultset_num.is_a? Integer
        resultset_num = sprintf "%03d", resultset_num
      end
      resultset_dir = Dir.glob(File.join(env.jkr_result_dir, resultset_num)+"*")
      if resultset_dir.size != 1
        raise RuntimeError.new "cannot specify resultset dir"
      end
      resultset_dir = resultset_dir.first

      plan_files = Dir.glob(File.join(resultset_dir, "*.plan"))
      if plan_files.size == 0
        raise RuntimeError.new "cannot find plan file"
      elsif plan_files.size > 1
        raise RuntimeError.new "there are two or more plan files"
      end
      plan_file_path = plan_files.first

      plan = Jkr::Plan.new(env, plan_file_path)

      Jkr::AnalysisUtils.define_analysis_utils(resultset_dir, plan)
      plan.analysis.call(plan)
      Jkr::AnalysisUtils.undef_analysis_utils(plan)
    end
  end
end