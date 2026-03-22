package com.example.demo.feature.farmer;

import com.example.demo.core.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * 农家业务逻辑处理层 (Service Layer)
 * 作用：承上启下。接收 Controller 传来的合法数据，执行业务规则运算，然后指派 Mapper 去存取数据库。
 */
@Service
public class FarmerService {
    private static final Logger logger = LoggerFactory.getLogger(FarmerService.class);

    // 依赖注入 (DI)。声明为 final，确保不可变性。
    private final FarmerMapper farmerMapper;

    // 推荐使用构造器注入（Constructor Injection），而不是 @Autowired。这样便于编写单元测试。
    public FarmerService(FarmerMapper farmerMapper) {
        this.farmerMapper = farmerMapper;
    }

    /**
     * 查询全量农家列表
     */
    public List<Farmer> getAllFarmers() {
        return farmerMapper.findAll();
    }

    /**
     * 注册新农家的核心业务方法
     * * @Transactional: 声明式事务。进入方法前开启事务，方法正常结束则 Commit，抛出异常则 Rollback。
     * 保证了数据操作的原子性（要么全成功，要么全失败）。
     */
    @Transactional
    public void registerFarmer(FarmerForm form) {
        // 关键节点打上日志，方便排错
        logger.info("开始执行新农家注册业务: 农家名称={}", form.getName());

        // 1. DTO -> Entity 的数据搬运（组装 DB 所需的对象）
        Farmer farmer = new Farmer();
        farmer.setName(form.getName());
        farmer.setPrefecture(form.getPrefecture());
        farmer.setCity(form.getCity());
        farmer.setAddressLine(form.getAddressLine());
        farmer.setRank(form.getRank());

        // 2. 调用数据层写入数据库
        farmerMapper.insert(farmer);

        logger.info("农家注册业务执行完毕，数据已落盘");
    }

    @Transactional
    public void updateFarmer(Integer id, FarmerForm form) {
        if (farmerMapper.findById(id).isEmpty()) throw new BusinessException("该农家不存在或已被删除！");
        Farmer farmer = new Farmer();
        farmer.setId(id); farmer.setName(form.getName()); farmer.setPrefecture(form.getPrefecture());
        farmer.setCity(form.getCity()); farmer.setAddressLine(form.getAddressLine()); farmer.setRank(form.getRank());
        farmerMapper.update(farmer);
    }

    @Transactional
    public void deleteFarmer(Integer id) {
        farmerMapper.deleteById(id);
    }
}